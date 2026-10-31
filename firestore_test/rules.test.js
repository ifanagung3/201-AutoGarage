const fs = require("node:fs");
const path = require("node:path");
const { after, before, beforeEach, test } = require("node:test");
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require("@firebase/rules-unit-testing");
const {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} = require("firebase/firestore");

const projectId = "demo-auto-garage";
let testEnv;

const booking = (userId, status = "Menunggu") => ({
  userId,
  userName: "Pelanggan",
  userPhone: "-",
  vehicleName: "Toyota Avanza",
  vehiclePlat: "B 1234 ABC",
  vehicleYear: 2020,
  vehicleKm: 50000,
  serviceName: "Servis Berkala",
  bookingDate: new Date("2026-10-25T00:00:00Z"),
  bookingTime: "09:00 WIB",
  estimatedCost: 350000,
  status,
  currentStep: 1,
  totalSteps: 5,
  notes: null,
  createdAt: new Date("2026-10-24T00:00:00Z"),
});

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      host: "127.0.0.1",
      port: 8085,
      rules: fs.readFileSync(path.join(__dirname, "..", "firestore.rules"), "utf8"),
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "users", "admin-1"), { role: "admin" });
    await setDoc(doc(db, "users", "customer-1"), { role: "user" });
    await setDoc(doc(db, "users", "customer-2"), { role: "user" });
    await setDoc(doc(db, "bookings", "booking-1"), booking("customer-1"));
    await setDoc(doc(db, "bookings", "booking-2"), booking("customer-2"));
    await setDoc(
      doc(db, "bookings", "booking-3"),
      booking("customer-1", "Selesai"),
    );
    await setDoc(doc(db, "vehicles", "vehicle-1"), { userId: "customer-1" });
  });
});

after(async () => {
  await testEnv.cleanup();
});

test("users can create own customer profile but cannot claim admin role", async () => {
  const db = testEnv.authenticatedContext("new-customer").firestore();

  await assertSucceeds(
    setDoc(doc(db, "users", "new-customer"), { role: "customer", name: "Baru" }),
  );
  await assertFails(
    setDoc(doc(db, "users", "attacker"), { role: "admin" }),
  );
});

test("users can read own profile and change only permitted profile fields", async () => {
  const db = testEnv.authenticatedContext("customer-1").firestore();

  await assertSucceeds(getDoc(doc(db, "users", "customer-1")));
  await assertFails(getDoc(doc(db, "users", "customer-2")));
  await assertSucceeds(
    updateDoc(doc(db, "users", "customer-1"), { name: "Nama baru" }),
  );
  await assertFails(
    updateDoc(doc(db, "users", "customer-1"), { role: "admin" }),
  );
});

test("customers can access only their bookings and cancel without editing booking data", async () => {
  const db = testEnv.authenticatedContext("customer-1").firestore();

  await assertSucceeds(getDoc(doc(db, "bookings", "booking-1")));
  await assertFails(getDoc(doc(db, "bookings", "booking-2")));
  await assertSucceeds(
    getDocs(
      query(collection(db, "bookings"), where("userId", "==", "customer-1")),
    ),
  );
  await assertFails(getDocs(collection(db, "bookings")));
  await assertSucceeds(
    setDoc(doc(db, "bookings", "booking-new"), booking("customer-1")),
  );
  await assertFails(
    setDoc(doc(db, "bookings", "booking-spoof"), booking("customer-2")),
  );
  await assertFails(
    setDoc(
      doc(db, "bookings", "booking-fake-completed"),
      booking("customer-1", "Selesai"),
    ),
  );
  await assertSucceeds(
    updateDoc(doc(db, "bookings", "booking-1"), {
      status: "Dibatalkan",
      currentStep: 0,
    }),
  );
  await assertFails(
    updateDoc(doc(db, "bookings", "booking-2"), {
      status: "Dibatalkan",
      currentStep: 0,
    }),
  );
  await assertFails(
    updateDoc(doc(db, "bookings", "booking-new"), { estimatedCost: 1 }),
  );
  await assertFails(
    updateDoc(doc(db, "bookings", "booking-3"), {
      status: "Dibatalkan",
      currentStep: 0,
    }),
  );
  await assertFails(deleteDoc(doc(db, "bookings", "booking-new")));
});

test("admins can manage bookings and service and promo catalogs", async () => {
  const db = testEnv.authenticatedContext("admin-1").firestore();

  await assertSucceeds(getDocs(collection(db, "bookings")));
  await assertSucceeds(
    updateDoc(doc(db, "bookings", "booking-1"), { estimatedCost: 300000 }),
  );
  await assertSucceeds(deleteDoc(doc(db, "bookings", "booking-2")));
  await assertSucceeds(
    setDoc(doc(db, "services", "service-1"), { name: "Servis" }),
  );
  await assertSucceeds(
    setDoc(doc(db, "promos", "promo-1"), { title: "Promo" }),
  );
});

test("customers can manage only their own vehicles", async () => {
  const db = testEnv.authenticatedContext("customer-1").firestore();

  await assertSucceeds(getDoc(doc(db, "vehicles", "vehicle-1")));
  await assertFails(getDoc(doc(db, "vehicles", "vehicle-other")));
  await assertSucceeds(
    setDoc(doc(db, "vehicles", "vehicle-new"), { userId: "customer-1" }),
  );
  await assertFails(
    setDoc(doc(db, "vehicles", "vehicle-spoof"), { userId: "customer-2" }),
  );
  await assertFails(
    updateDoc(doc(db, "vehicles", "vehicle-1"), { userId: "customer-2" }),
  );
  await assertSucceeds(deleteDoc(doc(db, "vehicles", "vehicle-1")));
});

test("catalog reads are limited as intended and unknown collections are denied", async () => {
  const anonymousDb = testEnv.unauthenticatedContext().firestore();
  const customerDb = testEnv.authenticatedContext("customer-1").firestore();

  await assertSucceeds(getDocs(collection(anonymousDb, "services")));
  await assertFails(getDocs(collection(anonymousDb, "promos")));
  await assertSucceeds(getDocs(collection(customerDb, "promos")));
  await assertFails(
    setDoc(doc(customerDb, "services", "service-customer"), { name: "Palsu" }),
  );
  await assertFails(
    setDoc(doc(customerDb, "promos", "promo-customer"), { title: "Palsu" }),
  );
  await assertFails(getDocs(collection(customerDb, "private-data")));
  await assertFails(
    setDoc(doc(customerDb, "private-data", "document"), { value: true }),
  );
});

const { readFileSync } = require('node:fs');
const { join } = require('node:path');
const { after, before, test } = require('node:test');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const { doc, setDoc, Timestamp } = require('firebase/firestore');

const rules = readFileSync(join(__dirname, '..', 'firestore.rules'), 'utf8');
let testEnv;
let bookingCounter = 0;

function booking(overrides = {}) {
  return {
    userId: 'customer-1',
    userName: 'Pelanggan',
    userPhone: '-',
    vehicleName: 'Toyota Avanza',
    vehiclePlat: 'B 1234 ABC',
    vehicleYear: 2020,
    vehicleKm: 50000,
    serviceName: 'Servis Berkala',
    bookingDate: Timestamp.fromDate(new Date('2026-10-25T00:00:00Z')),
    bookingTime: '09:00 WIB',
    estimatedCost: 350000,
    status: 'Menunggu',
    currentStep: 1,
    totalSteps: 5,
    notes: null,
    createdAt: Timestamp.fromDate(new Date('2026-10-24T00:00:00Z')),
    ...overrides,
  };
}

async function createBooking(data, id) {
  const db = testEnv.authenticatedContext('customer-1').firestore();
  const bookingId = id ?? `booking-${Date.now()}-${bookingCounter++}`;
  return setDoc(doc(db, 'bookings', bookingId), data);
}

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: 'demo-auto-garage-rules',
    firestore: {
      rules,
      host: '127.0.0.1',
      port: Number(process.env.FIRESTORE_EMULATOR_PORT || 8085),
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

test('allows a booking with the catalog price and valid service option', async () => {
  await assertSucceeds(createBooking(booking()));
  await assertSucceeds(
    createBooking(
      booking({
        serviceName: 'Tuning ECU & Remap Stage 1 / 2',
        serviceOption: 'Stage 2',
        estimatedCost: 800000,
      }),
    ),
  );
});

test('rejects forged prices and unsupported booking fields', async () => {
  await assertFails(
    createBooking(booking({ estimatedCost: 999999999 })),
  );
  await assertFails(
    createBooking(booking({ adminNote: 'untrusted' })),
  );
  await assertFails(
    createBooking(
      booking({
        serviceName: 'Tuning ECU & Remap Stage 1 / 2',
        estimatedCost: 800000,
      }),
    ),
  );
});

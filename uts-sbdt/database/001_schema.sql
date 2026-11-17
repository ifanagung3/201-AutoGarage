CREATE TABLE inference_history (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  input_payload JSONB NOT NULL,
  estimated_cost NUMERIC(14,2) NOT NULL CHECK(estimated_cost >= 0),
  estimated_duration NUMERIC(8,2) NOT NULL CHECK(estimated_duration >= 0),
  model_version VARCHAR(80) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_history_user_time ON inference_history(user_id,created_at DESC);
GRANT USAGE ON SCHEMA public TO app_writer,app_reader;
GRANT SELECT,INSERT ON inference_history TO app_writer;
GRANT SELECT ON inference_history TO app_reader;
GRANT USAGE,SELECT ON SEQUENCE inference_history_id_seq TO app_writer;

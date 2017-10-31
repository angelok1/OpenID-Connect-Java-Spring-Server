--
-- Turn off autocommit and start a transaction so that we can use the temp tables
--

--SET AUTOCOMMIT = OFF;

START TRANSACTION;

--
-- Insert scope information into the temporary tables.
-- 

INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('openid', 'log in using your identity', 'user', false, true, false, null),
  ('profile', 'basic profile information', 'list-alt', false, true, false, null),
  ('email', 'email address', 'envelope', false, true, false, null),
  ('address', 'physical address', 'home', false, true, false, null),
  ('phone', 'telephone number', 'bell', false, true, false, null),
  ('offline_access', 'offline access', 'time', false, false, false, null),
  ('smart', 'Details of SMART authorization', 'user', false, false),
  ('smart/orchestrate_launch', 'Orchestrate a launch with EHR context', 'user', false, false, false, null),
  ('launch', 'Launch with an existing context', 'user', false, false, false, null),
  ('launch/patient', 'Launch with patient context', 'user', false, false, false, null),
  ('launch/encounter', 'Launch with encounter context', 'user', false, false, false, null),
  ('launch/resource', 'Launch with resource context', 'user', false, false, false, null),
  ('launch/other', 'Launch with other context', 'user', false, false, false, null),
  ('search', 'SMART on FHIR search', 'user', false, false, false, null),
  ('summary', 'SMART on FHIR summary', 'user', false, false, false, null),
  ('user/*.*', 'Permission to read and write all resources that the current user can access', 'user', false, false, false, null),
  ('patient/*.*', 'Permission to read/write any resource for the current patient', 'user', false, false, false, null),
  ('patient/*.read', 'Read Permission to read any resource for the current patient', 'user', false, false, false, null),
  ('patient/*.write', 'Write Permission to read any resource for the current patient', 'user', false, false, false, null),
  ('patient/Patient/*.*', 'Read/Write to FHIR Patient Resources', 'user', false, false, false, null),
  ('patient/Patient/*.read', 'Read to FHIR Patient Resources', 'user', false, false, false, null),
  ('patient/Patient/*.write', 'Write to FHIR Patient Resources', 'user', false, false, false, null),
  ('patient/Observation/*.*', 'Read/Write to FHIR Observations Resources', 'user', false, false, false, null),
  ('patient/Observation/*.read', 'Read to FHIR Observations Resources', 'user', false, false, false, null),
  ('patient/Observation/*.write', 'Write to FHIR Observations Resources', 'user', false, false, false, null);

  
--
-- Merge the temporary scopes safely into the database. This is a two-step process to keep scopes from being created on every startup with a persistent store.
--

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description)
  SELECT scope, description, icon, restricted, default_scope, structured, structured_param_description FROM system_scope_TEMP
  ON CONFLICT(scope)
  DO NOTHING;

COMMIT;

--SET AUTOCOMMIT = ON;


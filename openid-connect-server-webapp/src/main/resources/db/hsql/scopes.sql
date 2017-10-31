--
-- Turn off autocommit and start a transaction so that we can use the temp tables
--

SET AUTOCOMMIT FALSE;

START TRANSACTION;

--
-- Insert scope information into the temporary tables.
-- 

INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('openid', 'log in using your identity', 'user', false, true),
  ('profile', 'basic profile information', 'list-alt', false, true),
  ('email', 'email address', 'envelope', false, true),
  ('address', 'physical address', 'home', false, true),
  ('phone', 'telephone number', 'bell', false, true),
  ('offline_access', 'offline access', 'time', false, false),
  ('smart', 'Details of SMART authorization', 'user', false, false),
  ('smart/orchestrate_launch', 'Orchestrate a launch with EHR context', 'user', false, false),
  ('launch', 'Launch with an existing context', 'user', false, false),
  ('launch/patient', 'Launch with patient context', 'user', false, false),
  ('launch/encounter', 'Launch with encounter context', 'user', false, false),
  ('launch/resource', 'Launch with resource context', 'user', false, false),
  ('launch/other', 'Launch with other context', 'user', false, false),
  ('search', 'SMART on FHIR search', 'user', false, false),
  ('summary', 'SMART on FHIR summary', 'user', false, false),
  ('user/*.*', 'Permission to read and write all resources that the current user can access', 'user', false, false),
  ('patient/*.*', 'Permission to read/write any resource for the current patient', 'user', false, false),
  ('patient/*.read', 'Read Permission to read any resource for the current patient', 'user', false, false),
  ('patient/*.write', 'Write Permission to read any resource for the current patient', 'user', false, false),
  ('patient/Patient/*.*', 'Read/Write to FHIR Patient Resources', 'user', false, false),
  ('patient/Patient/*.read', 'Read to FHIR Patient Resources', 'user', false, false),
  ('patient/Patient/*.write', 'Write to FHIR Patient Resources', 'user', false, false),
  ('patient/Observation/*.*', 'Read/Write to FHIR Observations Resources', 'user', false, false),
  ('patient/Observation/*.read', 'Read to FHIR Observations Resources', 'user', false, false),
  ('patient/Observation/*.write', 'Write to FHIR Observations Resources', 'user', false, false);


--
-- Merge the temporary scopes safely into the database. This is a two-step process to keep scopes from being created on every startup with a persistent store.
--

MERGE INTO system_scope
	USING (SELECT scope, description, icon, restricted, default_scope  FROM system_scope_TEMP) AS vals(scope, description, icon, restricted, default_scope)
	ON vals.scope = system_scope.scope
	WHEN NOT MATCHED THEN
	  INSERT (scope, description, icon, restricted, default_scope) VALUES(vals.scope, vals.description, vals.icon, vals.restricted, vals.default_scope);

COMMIT;

SET AUTOCOMMIT TRUE;

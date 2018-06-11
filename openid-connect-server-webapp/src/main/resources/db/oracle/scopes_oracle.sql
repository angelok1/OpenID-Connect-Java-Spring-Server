--
-- Insert scope information into the temporary tables.
-- 

INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('openid', 'log in using your identity', 'user', 0, 1);
INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('profile', 'basic profile information', 'list-alt', 0, 1);
INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('email', 'email address', 'envelope', 0, 1);
INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('address', 'physical address', 'home', 0, 1);
INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('phone', 'telephone number', 'bell', 0, 1, 0);
INSERT INTO system_scope_TEMP (scope, description, icon, restricted, default_scope) VALUES
  ('offline_access', 'offline access', 'time', 0, 0);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('smart', 'Details of SMART authorization', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('smart/orchestrate_launch', 'Orchestrate a launch with EHR context', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('launch', 'Launch with an existing context', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('launch/patient', 'Launch with patient context', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('launch/encounter', 'Launch with encounter context', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('launch/resource', 'Launch with resource context', 'user', 0, 0, 0, null);


INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('launch/other', 'Launch with other context', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('search', 'SMART on FHIR search', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('summary', 'SMART on FHIR summary', 'user', 0, 0, 0, null);

INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('user/*.*', 'Permission to read and write all resources that the current user can access', 'user', 0, 0, 0, null);

  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/*.*', 'Permission to read/write any resource for the current patient', 'user', 0, 0, 0, null);

  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/*.read', 'Read Permission to read any resource for the current patient', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/*.write', 'Write Permission to read any resource for the current patient', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Patient/*.*', 'Read/Write to FHIR Patient Resources', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Patient/*.read', 'Read to FHIR Patient Resources', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Patient/*.write', 'Write to FHIR Patient Resources', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Observation/*.*', 'Read/Write to FHIR Observations Resources', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Observation/*.read', 'Read to FHIR Observations Resources', 'user', 0, 0, 0, null);
  INSERT INTO system_scope (scope, description, icon, restricted, default_scope, structured, structured_param_description) VALUES
  ('patient/Observation/*.write', 'Write to FHIR Observations Resources', 'user', 0, 0, 0, null);
--
-- Merge the temporary scopes safely into the database. This is a two-step process to keep scopes from being created on every startup with a persistent store.
--

MERGE INTO system_scope
	USING (SELECT scope, description, icon, restricted, default_scope FROM system_scope_TEMP) vals
	ON (vals.scope = system_scope.scope)
	WHEN NOT MATCHED THEN
	  INSERT (id, scope, description, icon, restricted, default_scope) VALUES(system_scope_seq.nextval, vals.scope,
	  vals.description, vals.icon, vals.restricted, vals.default_scope);

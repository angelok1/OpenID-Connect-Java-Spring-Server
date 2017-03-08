/*******************************************************************************
 * Copyright 2017 The MITRE Corporation
 *   and the MIT Internet Trust Consortium
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

package org.mitre.oauth2.service;

import org.mitre.oauth2.model.DeviceCode;
import org.springframework.security.oauth2.provider.ClientDetails;

/**
 * @author jricher
 *
 */
public interface DeviceCodeService {

	/**
	 * @param dc
	 */
	public DeviceCode save(DeviceCode dc);

	/**
	 * @param userCode
	 * @return
	 */
	public DeviceCode lookUpByUserCode(String userCode);

	/**
	 * @param dc
	 */
	public DeviceCode approveDeviceCode(DeviceCode dc);

	/**
	 * @param deviceCode
	 * @param client
	 * @return
	 */
	public DeviceCode consumeDeviceCode(String deviceCode, ClientDetails client);

}
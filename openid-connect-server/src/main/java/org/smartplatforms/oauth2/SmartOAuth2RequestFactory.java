package org.smartplatforms.oauth2;

import com.google.gson.Gson;
import org.mitre.oauth2.service.ClientDetailsEntityService;
import org.mitre.openid.connect.request.ConnectOAuth2RequestFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.provider.AuthorizationRequest;
import org.springframework.security.oauth2.provider.ClientDetails;
import org.springframework.security.oauth2.provider.OAuth2Request;
import org.springframework.security.oauth2.provider.TokenRequest;
import org.springframework.stereotype.Service;
import static org.mitre.openid.connect.request.ConnectRequestParameters.AUD;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class SmartOAuth2RequestFactory extends ConnectOAuth2RequestFactory {

	private final static String LAUNCH_PARAM = "launch";
	@Autowired
	private LaunchContextResolver launchContextResolver;

    private Gson gson = new Gson();
/*
    Predicate<String> isLaunchContext = new Predicate<String>() {
		@Override
		public boolean apply(String input) {
			return input.startsWith("launch");
		}
	};
*/
	@Autowired
	public SmartOAuth2RequestFactory(
		ClientDetailsEntityService clientDetailsService) {
		super(clientDetailsService);
	}

	@Override
	public AuthorizationRequest createAuthorizationRequest(Map<String, String> inputParams) {
		AuthorizationRequest ret = super.createAuthorizationRequest(inputParams);

		HashMap<String, String> launchScopes = new HashMap<>(ret.getScope().stream()
			.filter(s -> s.startsWith(LAUNCH_PARAM))
			.collect(Collectors.toMap(s -> s, s -> "")));

		HashSet<String> otherScopes = new HashSet<>(ret.getScope().stream()
			.filter(s -> !s.startsWith(LAUNCH_PARAM))
			.collect(Collectors.toSet()));

		boolean requestingLaunch = launchScopes.size() > 0;// ret.getScope().stream().anyMatch(p -> p.startsWith(LAUNCH_PARAM));

		String launchId = ret.getRequestParameters().get(LAUNCH_PARAM);
		String aud = ret.getRequestParameters().get(AUD);
		if (!launchContextResolver.getServiceURL().equals(aud)) {
			ret.getExtensions().put("invalid_launch", "Incorrect service URL (aud): " + aud);
		} else {
			if (launchId != null) {
				try {
                    @SuppressWarnings("unchecked")
                    HashMap<String,String> params = (HashMap<String, String>)launchContextResolver.resolve(launchId, launchScopes);
                    ret.getExtensions().put("launch_context", gson.toJson(params));
				} catch (NeedUnmetException e1) {
					ret.getExtensions().put("invalid_launch", "Couldn't resolve launch id: " + launchId);
				}
			} else if (requestingLaunch) { // asking for launch, but no launch ID provided
				ret.getExtensions().put("external_launch_required", launchScopes);
			}
		}

		if(launchId != null){
			otherScopes.add(LAUNCH_PARAM);
		}

		ret.setScope(otherScopes);

		return ret;
	}

	@Override
	public OAuth2Request createOAuth2Request(ClientDetails client,
											 TokenRequest tokenRequest) {

		OAuth2Request ret = super.createOAuth2Request(client, tokenRequest);

		HashMap<String, String> launchScopes = new HashMap<>(ret.getScope().stream()
			.filter(s -> s.startsWith(LAUNCH_PARAM))
			.collect(Collectors.toMap(s -> s, s -> "")));

		boolean requestingLaunch = launchScopes.size() > 0;

		String launchId = ret.getRequestParameters().get(LAUNCH_PARAM);
		if (launchId != null) {
			try {
                @SuppressWarnings("unchecked")
                HashMap<String,String> params = (HashMap<String, String>)launchContextResolver.resolve(launchId, launchScopes);
                ret.getExtensions().put("launch_context", gson.toJson(params));
			} catch (NeedUnmetException e1) {
				ret.getExtensions().put("invalid_launch", "Couldn't resolve launch id: " + launchId);
			}
		} else if (requestingLaunch) { // asking for launch, but no launch ID provided
			ret.getExtensions().put("external_launch_required", launchScopes);
		}

		return ret;
	}
}

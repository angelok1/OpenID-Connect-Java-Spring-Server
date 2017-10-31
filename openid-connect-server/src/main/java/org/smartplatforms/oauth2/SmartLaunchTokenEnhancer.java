package org.smartplatforms.oauth2;

import com.google.gson.Gson;
import org.mitre.oauth2.model.OAuth2AccessTokenEntity;
import org.mitre.openid.connect.token.ConnectTokenEnhancer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class SmartLaunchTokenEnhancer extends ConnectTokenEnhancer {

	@Autowired
	private LaunchContextResolver launchContextResolver;

    private Gson gson = new Gson();

	@Override
	public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication)  {
		OAuth2AccessTokenEntity ret = (OAuth2AccessTokenEntity) super.enhance(accessToken, authentication);

        @SuppressWarnings("unchecked")
        String extensions = (String) authentication.getOAuth2Request().getExtensions().get("launch_context");

        if (extensions == null) {
            return ret;
        }

        @SuppressWarnings("unchecked")
        Map<String, String> contextMap = (HashMap<String,String>)gson.fromJson(extensions, HashMap.class);

		Set<LaunchContextEntity> context = contextMap.entrySet().stream()
			.map(m -> {
				LaunchContextEntity e = new LaunchContextEntity();
				e.setName(m.getKey());
				e.setValue(m.getValue());
				return e;
			})
			.collect(Collectors.toSet());

		ret.setLaunchContext(new HashSet<>(context));
		return ret;
	}

}

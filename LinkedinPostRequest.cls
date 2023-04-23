public with sharing class LinkedinPostRequest {
    @AuraEnabled
    public static Map<String,Object> postToLinkedin(String authCode,String body,String token) {
        System.debug('authCode'+authCode);
        System.debug('body'+body);
        System.debug('token'+token);
        Map<String,Object> bodyToReturn = new Map<String,Object>();
        String respIntegration;
        try {
            if(token==null || token=='') {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                String endPoint = 'https://www.linkedin.com/oauth/v2/accessToken?grant_type=authorization_code&client_id='FromApp'&client_secret='FromApp'&redirect_uri='FromApp'&code='+authCode;
                request.setEndpoint(endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                request.setHeader('Content-Length', '0');
    
                HttpResponse response = http.send(request);
    
                respIntegration = response.getBody();
                // Parse the JSON response

                Map<String,Object> accessTokenMap = (Map<String,Object>) Json.deserializeUntyped(response.getBody());
                if(accessTokenMap.containsKey('access_token')) {
                    respIntegration = fetchUserIdLinkedin((String) accessTokenMap.get('access_token'));
                    String userId = (String) ((Map<String,Object>) Json.deserializeUntyped(respIntegration)).get('id');
                    respIntegration = callLinkedinPostMethod(userId, body,(String) accessTokenMap.get('access_token'));
                }
                bodyToReturn.put('accToken',(String) accessTokenMap.get('access_token'));
            }
            else {
                respIntegration = fetchUserIdLinkedin(token);
                String userId = (String) ((Map<String,Object>) Json.deserializeUntyped(respIntegration)).get('id');
                respIntegration = callLinkedinPostMethod(userId, body,token);                
            }

            bodyToReturn.put('body',respIntegration);
            return bodyToReturn;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    
    }

    public static String fetchUserIdLinkedin(String token) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPoint = 'https://api.linkedin.com/v2/me?oauth2_access_token='+token;
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //request.setHeader('Content-Length', '0');     
        HttpResponse response = http.send(request);

        return response.getBody();   
    }
               
    public static String callLinkedinPostMethod(String userId, String postBody,String token) {
        Object bodyToSend = new Map<String,Object>();
        ((Map<String,Object>)bodyToSend).put('author','urn:li:person:'+userId);
        ((Map<String,Object>)bodyToSend).put('lifecycleState','PUBLISHED');
        ((Map<String,Object>)bodyToSend).put('specificContent',getSpecificContent(postBody));
        ((Map<String,Object>)bodyToSend).put('visibility',new Map<String,Object>{'com.linkedin.ugc.MemberNetworkVisibility'=>'PUBLIC'});
        //String body = '{"author": "urn:li:person:'+userId+'","lifecycleState": "PUBLISHED","specificContent": {"com.linkedin.ugc.ShareContent": {"shareCommentary": {"text": '+postBody+'},"shareMediaCategory": "NONE"}},"visibility": {"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"}}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPoint = 'https://api.linkedin.com/v2/ugcPosts';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Restli-Protocol-Version', '2.0.0');
        request.setHeader('Authorization', 'Bearer '+token);
        request.setBody(Json.serialize(bodyToSend));

        HttpResponse response = http.send(request);

        return response.getBody(); 
    }
    public static Map<String,Object> getSpecificContent(String postBody) {
/*         {
            "com.linkedin.ugc.ShareContent": {
                "shareCommentary": {
                    "text": "Hello World! This is my first Share on LinkedIn!"
                },
                "shareMediaCategory": "NONE"
            }
        }, */
        Map<String,Object> toReturn = new Map<String,Object>();
        Map<String,Object> insideToReturn = new Map<String,Object>();
        insideToReturn.put('shareMediaCategory','NONE');
        insideToReturn.put('shareCommentary',new Map<String,Object>{'text'=>postBody});
        toReturn.put('com.linkedin.ugc.ShareContent',insideToReturn);

        return toReturn;
    }
}
package com.fidelidade.teladoc;


import android.graphics.Color;
import android.util.Base64;
import android.util.Log;

import com.advancemedical.multicare.sdkdemo.R;
import com.teladoc.members.sdk.Teladoc;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TeladocPlugin extends CordovaPlugin {

    private CallbackContext callbackContext;
    private String TAG = TeladocPlugin.class.getSimpleName();
    private String loginToken = "";
    private String tokenApp = "";
    private Utils utils = new Utils();

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        setApiKey();

        if (action != null) {

            switch (Actions.getActionByName(action)) {
                case LOGIN:
                    login(args);
                    break;
                case LOGIN_TOKEN:
                    loginWithToken(args);
                    break;
                case LOGOUT:
                    logout();
                    break;
                case ACCOUNT_SETTINGS:
                    accountSettings();
                    break;
                case IMAGE_UPLOAD:
                    startImageUpload();
                    break;
                case SHOW_CONSULTATIONS:
                    showConsultations();
                    break;
                case REQ_CONSULTATION:
                    requestConsultation();
                    break;
                case GET_CONSULTATIONS:
                    getConsultations();
                    break;
                case DASHBOARD:
                    showDashboard();
                    break;
                case CHANGE_COLORS:
                    changeColors(args);
                    break;
                case INVALID:
                    callbackContext.error(Actions.INVALID.getDescription());
                    break;
            }
        } else {
            Log.v(TAG, Actions.INVALID.getDescription());
            callbackContext.error(Actions.INVALID.getDescription());
            return false;
        }

        return true;
    }

    /**
     * Chance color
     *
     * @param args the arguments
     */
    private void changeColors(JSONArray args) throws JSONException {

        JSONObject objColors = args.getJSONObject(0);

        if (objColors == null) {
            callbackContext.error("Invalid colors!");
            return;
        }

        int primaryColor = this.utils.convertStringToColor(objColors.getString("primaryColor"));
        int secondaryColor = this.utils.convertStringToColor(objColors.getString("secondaryColor"));
        int tertiaryColor = this.utils.convertStringToColor(objColors.getString("tertiaryColor"));

        Teladoc.getInstance(this.cordova.getContext()).setColors(primaryColor, secondaryColor, tertiaryColor, Color.DKGRAY,
                Color.YELLOW);
    }

    /**
     * Account settings
     */
    private void accountSettings() {
        Teladoc.getInstance(this.cordova.getContext()).accountSettings(new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "accountSettings success");
                callbackContext.success("accountSettings success ");
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "accountSettings failure, code: " + code + ", message: " + message);
                callbackContext.error(message);
            }
        });
    }

    /**
     * Get consultations
     */
    private void getConsultations() {
        Log.i(TAG, "executing getMessages()");

        Teladoc.getInstance(this.cordova.getContext()).getConsults(new Teladoc.OnCompleteWithJSONArrayListener() {
            @Override
            public void onSuccess(JSONArray result) {
                Log.i(TAG, "getMessages success: " + result);
                callbackContext.success(result);
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "getConsults failure, code: " + code + ", message: " + message);
            }
        });
    }

    /**
     * Show consultations
     */
    private void showConsultations() {
        Teladoc.getInstance(this.cordova.getContext()).consultList(new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                callbackContext.success("showConsultations success");
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "getConsults failure, code: " + code + ", message: " + message);
                callbackContext.error(message);
            }
        });
    }

    /**
     * Logout in the SDK
     */
    private void logout() {
        Teladoc.getInstance(this.cordova.getActivity().getApplicationContext()).logout();
    }

    /**
     * Login with token in Teladoc api
     *
     * @param args the arguments
     */
    private void loginWithToken(JSONArray args) throws JSONException {
        loginToken = args.getString(0);
        Log.i(TAG, "executing loginWithToken: " + loginToken);

        Teladoc.getInstance(this.cordova.getContext()).loginWithToken(loginToken, new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Teladoc.TDRegistrationStatus regStatus = Teladoc.getInstance(cordova.getContext()).getRegistrationStatus();
                Log.i(TAG, "login success, registration status: " + regStatus);
                callbackContext.success("Login success");
            }

            @Override
            public void onFailure(int errorCode, String errorString) {
                Teladoc.TDRegistrationStatus regStatus = Teladoc.getInstance(cordova.getContext()).getRegistrationStatus();
                Log.e(TAG, "login failure, code: " + errorCode + ", error: " + errorString + ", registration status: " + regStatus);
                callbackContext.error(errorString);
            }
        });
    }

    /**
     * Login in Teladoc api
     *
     * @param args the arguments
     */
    private void login(JSONArray args) throws JSONException {
        loginToken = getLoginToken(args);
        Log.i(TAG, "executing loginWithToken: " + loginToken);

        Teladoc.getInstance(this.cordova.getContext()).loginWithToken(loginToken, new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Teladoc.TDRegistrationStatus regStatus = Teladoc.getInstance(cordova.getContext()).getRegistrationStatus();
                Log.i(TAG, "login success, registration status: " + regStatus);
                callbackContext.success("Login success");
            }

            @Override
            public void onFailure(int errorCode, String errorString) {
                Teladoc.TDRegistrationStatus regStatus = Teladoc.getInstance(cordova.getContext()).getRegistrationStatus();
                Log.e(TAG, "login failure, code: " + errorCode + ", error: " + errorString + ", registration status: " + regStatus);
                callbackContext.error(errorString);
            }
        });
    }

    /**
     * Start image upload
     */
    private void startImageUpload() {
        Log.i(TAG, "executing imageUpload()");

        Teladoc.getInstance(this.cordova.getContext()).imageUpload(new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "imageUpload success");
                callbackContext.success("image upload success");
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "imageUpload failure, code: " + code + ", message: " + message);
                callbackContext.error(message);
            }
        });
    }

    /**
     * Show the dashboard
     */
    private void showDashboard() {
        Teladoc.getInstance(this.cordova.getContext()).dashboard(new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "startDashboard success");
                callbackContext.success("Dashboard success");
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "startDashboard failure, code: " + code + ", message: " + message);
                callbackContext.error("Voce parece nao estar logado");
            }
        });
    }

    /**
     * Request consultation
     */
    private void requestConsultation() {
        Teladoc.getInstance(this.cordova.getContext()).requestConsult(new Teladoc.OnCompleteListener() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "requestConsult success");
                callbackContext.success("Request Consult success");
            }

            @Override
            public void onFailure(int code, String message) {
                Log.e(TAG, "requestConsult failure, code: " + code + ", message: " + message);
                callbackContext.error(message);
            }
        });
    }

    private String getLoginToken(JSONArray args) throws JSONException {
        JSONObject login = (JSONObject) args.get(0);
        JSONObject loginToken = new JSONObject();
        String phoneNumber = utils.generatePhoneNumber();
        try {
            loginToken.put("issuer", "MulticareSDK");
            loginToken.put("timestamp", System.currentTimeMillis());
            loginToken.put("name", login.getString("firstName"));
            loginToken.put("surname", login.getString("lastName"));
            loginToken.put("birth_date", login.getString("dob"));
            loginToken.put("client_code", login.getString("memberId"));
            loginToken.put("gender", "male");
            loginToken.put("country", "PT");
            loginToken.put("language", "pt");
            loginToken.put("email", phoneNumber + "@teladoc.io");
            loginToken.put("phone_prefix", "351");
            loginToken.put("phone", phoneNumber);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        String auth = loginToken.toString();

        try {
            auth = Base64.encodeToString(utils.encrypt(auth, this.cordova.getContext()), Base64.NO_WRAP);
        } catch (Exception e) {
            android.util.Log.e(TAG, "token encoding failure: " + e.getMessage());
        }

        return auth;
    }

    private enum Actions {

        LOGIN("doTeladocLogin", "The login action."),
        LOGIN_TOKEN("doTeladocLoginWithToken", "The login with token action."),
        LOGOUT("doTeladocLogout", "The logout action."),
        DASHBOARD("showDashboard", "The dashboard action."),
        IMAGE_UPLOAD("showImageUpload", "The show image upload action."),
        SHOW_CONSULTATIONS("showConsultations", "The show consultations action."),
        REQ_CONSULTATION("requestConsultation", "The request consultation action."),
        ACCOUNT_SETTINGS("showTeladocAccountSettings", "The account settings action."),
        GET_CONSULTATIONS("getTeladocConsultations", "The retrieve consultations action."),
        CHANGE_COLORS("changeColor", "The set color application action."),
        INVALID("", "Invalid or not found action!");

        private String action;
        private String description;

        Actions(String action, String description) {
            this.action = action;
            this.description = description;
        }

        public String getDescription() {
            return description;
        }

        public static Actions getActionByName(String action) {
            for (Actions a : Actions.values()) {
                if (a.action.equalsIgnoreCase(action)) {
                    return a;
                }
            }
            return INVALID;
        }
    }

    /**
     * Set the SDK teladoc api key (DEV or PRODUCTION)
     */
    private void setApiKey() {
        String isProduction = this.cordova.getContext().getString(R.string.TELADOC_ISPRODUCTION);
        String apiKey = this.cordova.getContext().getString(R.string.TELADOC_API_KEY);
        String environment = this.cordova.getActivity().getString(R.string.TELADOC_SERVER);

        if (isProduction.equalsIgnoreCase("false")) {
            Teladoc.getInstance(this.cordova.getActivity().getApplicationContext()).setTestApiKey(apiKey, environment);
        } else {
            Teladoc.getInstance(this.cordova.getActivity().getApplicationContext()).setApiKey(apiKey);
        }

        Teladoc.getInstance(this.cordova.getActivity().getApplicationContext()).setOnErrorEventListener((errorString, isLoggedIn) -> Log.w(TAG, "onError, errorString: " + errorString));
        Teladoc.getInstance(this.cordova.getActivity().getApplicationContext()).setOnTrackingEventListener(event -> Log.i(TAG, "tracking event: " + event));
    }
}

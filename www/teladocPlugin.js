var exec = require("cordova/exec");

function Teladoc() {}

Teladoc.prototype.teladocLoginWithToken = function (successCallback, errorCallback, encryptedKey) {
    exec(successCallback, errorCallback, "TeladocPlugin", "doTeladocLoginWithToken", [encryptedKey]);
};

Teladoc.prototype.teladocDashboard = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showDashboard", []);
};

Teladoc.prototype.teladocImageUpload = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showImageUpload", []);
};

Teladoc.prototype.teladocConsultationList = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showConsultations", []);
};

Teladoc.prototype.teladocRequestConsultation = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "requestConsultation", []);
};

Teladoc.prototype.teladocAccountSettings = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showTeladocAccountSettings", []);
};

Teladoc.prototype.teladocLogout = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "doTeladocLogout", []);
};

Teladoc.prototype.getConsultations = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "getTeladocConsultations", []);
};

Teladoc.prototype.changeColor = function (successCallback, errorCallback, colors) {
    exec(successCallback, errorCallback, "TeladocPlugin", "changeColor", [colors]);
};

Teladoc.install = function() {
   if !(window.plugins) {
      windows.plugins = {}
   }

   window.plugins.Teladoc = new Teladoc();
   return window.plugins.Teladoc;
}

cordova.addConstructor(Teladoc.install);
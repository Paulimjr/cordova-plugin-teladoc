var exec = require("cordova/exec");

function Teladoc() {}

exports.teladocLoginWithToken = function (successCallback, errorCallback, encryptedKey) {
    exec(successCallback, errorCallback, "TeladocPlugin", "doTeladocLoginWithToken", [encryptedKey]);
};

exports.teladocDashboard = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showDashboard", []);
};

exports.teladocImageUpload = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showImageUpload", []);
};

exports.teladocConsultationList = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showConsultations", []);
};

exports.teladocRequestConsultation = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "requestConsultation", []);
};

exports.teladocAccountSettings = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "showTeladocAccountSettings", []);
};

exports.teladocLogout = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "doTeladocLogout", []);
};

exports.getConsultations = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TeladocPlugin", "getTeladocConsultations", []);
};

exports.changeColor = function (successCallback, errorCallback, colors) {
    exec(successCallback, errorCallback, "TeladocPlugin", "changeColor", [colors]);
};

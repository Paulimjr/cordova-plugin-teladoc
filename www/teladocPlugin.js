var exec = require("cordova/exec");

/**
 * Innovagency - Team Mobile
 *
 * Paulo Cesar & Pedro Remedios
 * @returns {Teladoc}
 */

/**function Teladoc() {
    
}
**/
exports.teladocLogin = function(successCallback, errorCallback, encryptedKey) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'doTeladocLogin', [encryptedKey]);
};
           
exports.teladocLoginWithToken = function(successCallback, errorCallback, encryptedKey) {
    exec(successCallback, errorCallback, 'TeladocPlugin', 'doTeladocLoginWithToken', [encryptedKey]);
};

exports.teladocDashboard = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'TeladocPlugin', 'showDashboard', []);
};
               
exports.teladocImageUpload = function(successCallback, errorCallback) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'showImageUpload', []);
};

exports.teladocConsultationList = function(successCallback, errorCallback) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'showConsultations', []);
};
               
exports.teladocRequestConsultation = function(successCallback, errorCallback) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'requestConsultation', []);
};
               
exports.teladocAccountSettings = function(successCallback, errorCallback) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'showTeladocAccountSettings', []);
};

exports.teladocLogout = function(successCallback, errorCallback) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'doTeladocLogout', []);
};
               
exports.getConsultations = function(successCallback, errorCallback) {
  exec(successCallback, errorCallback, 'TeladocPlugin', 'getTeladocConsultations', []);
};
               
exports.setPrimaryColor = function(successCallback, errorCallback, color) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'setPrimaryColor', [color]);
};

exports.setSecondaryColor = function(successCallback, errorCallback, color) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'setSecondaryColor', [color]);
};

exports.setTertiaryColor = function(successCallback, errorCallback, color) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'setTertiaryColor', [color]);
};

exports.setStatusBarColor = function(successCallback, errorCallback, color) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'setStatusBarColor', [color]);
};

exports.changeColor = function(successCallback, errorCallback, colors) {
   exec(successCallback, errorCallback, 'TeladocPlugin', 'changeColor', [colors]);
};

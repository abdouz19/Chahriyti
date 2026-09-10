// Cloud Function exports

const { generateLicense } = require('./generateLicense');
const { getDashboardStats } = require('./getDashboardStats');

const { createManager } = require('./createManager');
const { updateUserStatus } = require('./updateUserStatus');
const { sendToDelivery } = require('./sendToDelivery');

// Pool license system
const { generateLicenseBatch } = require('./generateLicenseBatch');
const { activateLicense } = require('./activateLicense');
const { assignLicense } = require('./assignLicense');

exports.generateLicense = generateLicense;
exports.getDashboardStats = getDashboardStats;
exports.createManager = createManager;
exports.updateUserStatus = updateUserStatus;
exports.sendToDelivery = sendToDelivery;

// Pool license system
exports.generateLicenseBatch = generateLicenseBatch;
exports.activateLicense = activateLicense;
exports.assignLicense = assignLicense;

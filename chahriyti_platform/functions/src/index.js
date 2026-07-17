// Cloud Function exports

const { generateLicense } = require('./generateLicense');
const { getDashboardStats } = require('./getDashboardStats');

const { createManager } = require('./createManager');
const { updateUserStatus } = require('./updateUserStatus');
const { sendToDelivery } = require('./sendToDelivery');

exports.generateLicense = generateLicense;
exports.getDashboardStats = getDashboardStats;
exports.createManager = createManager;
exports.updateUserStatus = updateUserStatus;
exports.sendToDelivery = sendToDelivery;

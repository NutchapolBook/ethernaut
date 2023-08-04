"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var address_1 = require("@ethersproject/address");
var futureAddress = (0, address_1.getContractAddress)({
    //contract address
    from: '0x1Ad1eb72A993FBEDAadF3cD3fD451B70636D0E9A',
    nonce: 1
});
console.log(futureAddress);
//# sourceMappingURL=17-attackRecovery.js.map
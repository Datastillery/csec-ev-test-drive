const moment = require('moment');
const {BetterSmartExperienceMySQLPool} = require('../../utils/BetterSmartExperienceMySQLPool');
const ApiHelpers = require('../ApiHelpers');
const extend = require('extend');

class PatchCarState { //Should be a patch in terraform/AWS. We had issues with non post/get api gateway endpoints. This is set up as a post as a workaround
    constructor(pool, moment, ApiHelpers) {
        this.moment = moment;
        this.pool = pool;
        this.ApiHelpers = ApiHelpers;
    }

    handleEvent(event, context, callback) {
        const body = JSON.parse(event.body);
        const carId = body.carId;
        const active = body.active;
        const pin = body.pin;
        this.verifyCar(carId)
            .then((persistedCar) => this.patchCarState(car, persistedCar, active))
            .then((data) => this.successHandler(callback, data), (error) => this.errorHandler(callback, error))
        ;
    }

    verifySlot(car) {
        return this.pool.doQuery("select * from car where id = ?", car.id);
    }

    patchCarState(car, persistedCar, active) {
        console.log(persistedCar);
        if (persistedCar[0]) {
            var state = active ? 1 : 0;
            return this.pool.doQuery("update car_schedule set active = ? where car_id = ? and date >= ?", [state, car.id, this.moment().format('YYYY-MM-DD')]);
        } else {
            return Promise.reject("Car not found");
        }
    }

    successHandler(callback, data) {
        this.pool.end();
        console.log(`Done`);
        const response = extend({message: "Success"}, data);
        this.ApiHelpers.httpResponse(callback, 200, response);
    }

    errorHandler(callback, error) {
        this.pool.end();
        console.log(`ERROR: ${error}`);
        if (error !== undefined && error.toString().indexOf("Car not found") === 0) {
            return this.ApiHelpers.httpResponse(callback, 404, {errors: error});
        }
        this.ApiHelpers.httpResponse(callback, 500, {errors: 'An error occurred when processing your request.'});
    }
}

exports.PatchCarState = PatchCarState;
exports.handler = (event, context, callback) => {
    const handler = new PatchCarState(new BetterSmartExperienceMySQLPool(), moment, ApiHelpers);
    handler.handleEvent(event, context, callback);
};
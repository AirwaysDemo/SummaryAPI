import ballerina/http;
import ballerina/jwt;
import ballerina/io;

const string DEFAULT_USER = "default";

service /airways on new http:Listener(9092) {

    resource function get frequentMiles/[string actualMiles](http:Headers headers) returns string|http:BadRequest|error {
        string|error jwtAssertion = headers.getHeader("x-jwt-assertion");
        io:println(jwtAssertion);
        if (jwtAssertion is error) {
            http:BadRequest badRequest = {
                body: {
                    "error": "Bad Request",
                    "error_description": "Error while getting the JWT token"
                }
            };
            return badRequest;
        }
        [jwt:Header, jwt:Payload] [_, payload] = check jwt:decode(jwtAssertion);
        json user = payload.toJson();
        string milesTier = (check user.milesTier).toString();

        

        return milesTier;
        // return username;
    }
}


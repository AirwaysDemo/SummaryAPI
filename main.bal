import ballerina/http;
import ballerina/jwt;
import ballerina/io;

const string DEFAULT_USER = "default";

service /readinglist on new http:Listener(9092) {

    resource function get books(http:Headers headers) returns string|http:BadRequest|error {
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
        string username = payload.sub is string ? <string>payload.sub : DEFAULT_USER;
        io:print(username);

        return jwtAssertion;
        // return username;
    }
}


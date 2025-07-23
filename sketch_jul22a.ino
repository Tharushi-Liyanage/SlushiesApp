#include <ESP8266WiFi.h>
#include <WiFiClientSecureBearSSL.h>
#include <ArduinoJson.h>

// Wi-Fi credentials
const char* ssid = "lasindupc";
const char* password = "lasindu96";

// Firestore and Firebase info
const char* projectId = "slushies-app";
const char* firestoreHost = "firestore.googleapis.com";
const char* accessToken = "ya29.YOUR_FIREBASE_ACCESS_TOKEN";
//const char* apikey = "AIzaSyDXl0Bv3K7vi_DGh_udI6KJuQFEqq5sjrY"

// Relay pins
#define MANGO_RELAY D6
#define PINEAPPLE_RELAY D5
#define WATER_RELAY D7
#define SUGAR_RELAY D8

BearSSL::WiFiClientSecure client;

void setup() {
  Serial.begin(9600);

  // Setup relay pins
  pinMode(MANGO_RELAY, OUTPUT);
  pinMode(PINEAPPLE_RELAY, OUTPUT);
  pinMode(WATER_RELAY, OUTPUT);
  pinMode(SUGAR_RELAY, OUTPUT);

  digitalWrite(MANGO_RELAY, LOW);
  digitalWrite(PINEAPPLE_RELAY, LOW);
  digitalWrite(WATER_RELAY, LOW);
  digitalWrite(SUGAR_RELAY, LOW);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected!");

  // ⚠️ Disable certificate verification for testing (insecure)
  client.setInsecure();

  // Build Firestore URL
  String url = "/v1/projects/" + String(projectId) + "/databases/(default)/documents/orders/order1";

  Serial.print("Requesting: ");
  Serial.println(url);

  // Connect to Firestore
  if (!client.connect(firestoreHost, 443)) {
    Serial.println("Firestore connection failed!");
    return;
  }

  // Send HTTPS GET request
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + firestoreHost + "\r\n" +
               "Authorization: Bearer " + accessToken + "\r\n" +
               "Connection: close\r\n\r\n");

  // Wait for response headers
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") break;
  }

  // Read response body
  String response = client.readString();
  Serial.println("Firestore Response:");
  Serial.println(response);

  // Parse JSON response
  const size_t capacity = 2048;
  DynamicJsonDocument doc(capacity);
  DeserializationError error = deserializeJson(doc, response);

  if (error) {
    Serial.print("JSON parse error: ");
    Serial.println(error.c_str());
    return;
  }

  // Extract data
  String drink = doc["fields"]["drink"]["stringValue"];
  bool addWater = doc["fields"]["addWater"]["booleanValue"];
  bool addSugar = doc["fields"]["addSugar"]["booleanValue"];

  Serial.println("Order received:");
  Serial.println("Drink: " + drink);
  Serial.print("Add Water: "); Serial.println(addWater);
  Serial.print("Add Sugar: "); Serial.println(addSugar);

  // Dispense based on drink type
  if (drink == "Mango") {
    Serial.println("Dispensing Mango Juice...");
    digitalWrite(MANGO_RELAY, HIGH);
    delay(3000); // Dispense duration
    digitalWrite(MANGO_RELAY, LOW);
  } else if (drink == "Pineapple") {
    Serial.println("Dispensing Pineapple Juice...");
    digitalWrite(PINEAPPLE_RELAY, HIGH);
    delay(3000);
    digitalWrite(PINEAPPLE_RELAY, LOW);
  }

  // Add water
  if (addWater) {
    Serial.println("Adding Water...");
    digitalWrite(WATER_RELAY, HIGH);
    delay(2000);
    digitalWrite(WATER_RELAY, LOW);
  }

  // Add sugar
  if (addSugar) {
    Serial.println("Adding Sugar...");
    digitalWrite(SUGAR_RELAY, HIGH);
    delay(2000);
    digitalWrite(SUGAR_RELAY, LOW);
  }

  Serial.println("Dispensing complete.");
}

void loop() {
  // Nothing in loop for now
}

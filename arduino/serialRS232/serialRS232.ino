void setup() {
  Serial.begin(110);
  Serial1.begin(110);
}

void loop() {
  Serial.print("P");
  Serial1.print("P");
  delay(1000);
}

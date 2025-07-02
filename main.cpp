#ifdef USE_FAST_LED

// NeoPixel LED for M5Stamp C3
#  include <FastLED.h>
#  define NEOPIXEL_PIN 2
#  define NEOPIXEL_NUM 1
   CRGB leds[NEOPIXEL_NUM];
#else

// for simple LED connected to GPIO
#  include <Arduino.h>
#  define LED_PIN 1

#endif

   void setup() {
#ifdef USE_FAST_LED
  FastLED.addLeds<NEOPIXEL, NEOPIXEL_PIN>(leds, NEOPIXEL_NUM);
#else
  pinMode(LED_PIN, OUTPUT);
#endif
}

void loop() {

#ifdef USE_FAST_LED
  leds[0] = CRGB::Green; FastLED.show(); delay(300);
  leds[0] = CRGB::Blue;  FastLED.show(); delay(300);
  leds[0] = CRGB::Red;   FastLED.show(); delay(300);
#else
  digitalWrite(LED_PIN, HIGH);
  delay(500);
  digitalWrite(LED_PIN, LOW);
  delay(500);
#endif
}

#include <FastLED.h>

// M5Stamp C3 GPIO
//   LED: GPIO 2
//   Button: GPIO 3
// https://docs.m5stack.com/ja/core/stamp_c3

#define NUM_LEDS 1
#define LED_PIN  2
#define BTN_PIN  3

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<NEOPIXEL, LED_PIN>(leds, NUM_LEDS);
}

void loop() {
  leds[0] = CRGB::Green; FastLED.show(); delay(300);
  leds[0] = CRGB::Blue;  FastLED.show(); delay(300);
  leds[0] = CRGB::Red;   FastLED.show(); delay(300);
}

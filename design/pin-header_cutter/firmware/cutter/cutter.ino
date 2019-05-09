#include <TM1637Display.h>
#include <Servo.h>

const int CLK = 6, DIO = 7, SERVO = 9, BTN = 4;
TM1637Display display(CLK, DIO);

Servo servo;  // create servo object to control a servo
int n = 0;

void setup() {
  pinMode(BTN, INPUT_PULLUP);
  servo.attach(SERVO);  // attaches the servo on pin 9 to the servo object

  display.setBrightness(0x0f);
  display.showNumberDec(n, false);
  Serial.begin(9600);
}

unsigned long nextMillis = 0;
const int steps = 7;
byte step = 0;
int positions[] = {10, 30, 0, 20, 0, 10, 50};
int waits[]  = {300, 300, 800, 300, 500, 400, 400};

void loop() {
  if (!digitalRead(BTN))
  {
    Serial.println("Button1");
    delay(100);
    while (digitalRead(BTN));
    while (!digitalRead(BTN));

    display.showNumberDec(++n, false);
    Serial.println("Button2");
    nextMillis = millis() + 1000;
  }

  if (n > 0)
  {
    if (millis() > nextMillis)
    {
      servo.write(positions[step]);
      nextMillis = millis() + waits[step];

      step++;
      if (step >= steps)
      {
        step = 0;
        display.showNumberDec(--n, false);
      }
    }
  }
}

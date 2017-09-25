
// CONNECTIONS:
// DS1307 SDA --> SDA
// DS1307 SCL --> SCL
// DS1307 VCC --> 5v
// DS1307 GND --> GND

/* for software wire use below
  #include <SoftwareWire.h>  // must be included here so that Arduino library object file references work
  #include <RtcDS1307.h>

  SoftwareWire myWire(SDA, SCL);
  RtcDS1307<SoftwareWire> Rtc(myWire);
  for software wire use above */

/* for normal hardware wire use below */
#include <Wire.h> // must be included here so that Arduino library object file references work
#include <RtcDS1307.h>
RtcDS1307<TwoWire> Rtc(Wire);
/* for normal hardware wire use above */

void setup ()
{
  Serial.begin(9600);
  Rtc.Begin();

  if (!Rtc.GetIsRunning())
  {
    Serial.println("RTC was not actively running, starting now");
    Rtc.SetIsRunning(true);
  }
  Rtc.SetSquareWavePin(DS1307SquareWaveOut_Low);
}

unsigned long nextSerialReport = 0;
void loop ()
{
  if (!Rtc.IsDateTimeValid())
  {
    Serial.println("RTC lost confidence in the DateTime!");
  }
  else
  {
    RtcDateTime now = Rtc.GetDateTime();

    if (millis() > nextSerialReport)
    {
      printDateTime(now);
      Serial.println();
      nextSerialReport = millis() + 1000;
    }

    delay(100); // 1 seconds
  }
}

#define countof(a) (sizeof(a) / sizeof(a[0]))

void printDateTime(const RtcDateTime& dt)
{
  char datestring[20];

  snprintf_P(datestring,
             countof(datestring),
             PSTR("%02u/%02u/%04u %02u:%02u:%02u"),
             dt.Day(),
             dt.Month(),
             dt.Year(),
             dt.Hour(),
             dt.Minute(),
             dt.Second() );
  Serial.print(datestring);
}


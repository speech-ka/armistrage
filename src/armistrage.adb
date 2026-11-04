with Sf.Window.VideoMode;
use Sf, Sf.Window, Sf.Window.VideoMode;
with Sf.Window.Event;  use Sf.Window.Event;
with Sf.Window.Window; use Sf.Window.Window;

with Sf.Graphics.Color;
use Sf.Graphics, Sf.Graphics.Color;
with Sf.Graphics.RenderWindow; use Sf.Graphics.RenderWindow;
with Sf.Graphics.Sprite;       use Sf.Graphics.Sprite;
with Sf.Graphics.Texture;      use Sf.Graphics.Texture;
with Sf.Graphics.Font;         use Sf.Graphics.Font;
with Sf.Graphics.Text;         use Sf.Graphics.Text;

with Sf.Audio.Music;
use Sf.Audio, Sf.Audio.Music;

with Sf.System;       use Sf.System;
with Sf.System.Clock; use Sf.System.Clock;
with Sf.System.Time;  use Sf.System.Time;

with Ada.Text_IO;

procedure Armistrage is

   Resource_Unavailable : exception;

   Mode    : constant VideoMode.sfVideoMode :=
     (width => 800, height => 600, bitsPerPixel => 32);
   Window  : sfRenderWindow_Ptr;
   Texture : sfTexture_Ptr;
   Sprite  : sfSprite_Ptr;
   Font    : sfFont_Ptr;
   Text    : sfText_Ptr;
   event   : sfEvent;

   Game_Clock     : sfClock_Ptr := Clock.create;
   Acc            : sfTime := Sf.System.Time.Zero;
   Dt             : sfTime;
   Fixed_Dt       : constant sfInt64 := 16_666;
   Max_Frame_Time : constant sfInt64 := 250_000;
   Max_Updates    : constant Integer := 5;
   Updates        : Integer;
   Alpha          : Float;

   procedure UpdateFixed is
   begin
      Ada.Text_IO.Put_Line ("update fixed");
   end UpdateFixed;

   procedure Update (Dt : sfTime; Alpha : Float) is
   begin
      clear (Window);

      drawSprite (Window, Sprite);

      drawText (Window, Text);

      display (Window);
      Ada.Text_IO.Put_Line
        ("update dt: "
         & sfInt64'Image (Dt.microseconds)
         & Float'Image (Alpha));
   end Update;

begin
   Window := create (Mode, "SFML window");

   Texture := createFromFile ("./ASFML_Logo.png");

   if Texture = null then
      raise Resource_Unavailable;
   end if;

   Sprite := Sf.Graphics.Sprite.create;
   setTexture (Sprite, Texture);
   setPosition (Sprite, (x => 200.0, y => 200.0));

   Font := createFromFile ("./tuffy.ttf");

   if Font = null then
      raise Resource_Unavailable;
   end if;

   Text := create;
   setString (Text, "Hello, Ada!");
   setFont (Text, Font);
   setCharacterSize (Text, 50);

   while isOpen (Window) loop
      while pollEvent (Window, event) loop
         if event.eventType = sfEvtClosed then
            close (Window);
         end if;
      end loop;

      Dt := Sf.System.Clock.restart (Game_Clock);
      if Dt.microseconds > Max_Frame_Time then
         Dt.microseconds := Max_Frame_Time;
      end if;
      Acc.microseconds := Acc.microseconds + Dt.microseconds;
      Updates := 0;
      while Acc.microseconds >= Fixed_Dt and then Updates < Max_Updates loop
         UpdateFixed;
         Acc.microseconds := Acc.microseconds - Fixed_Dt;
         Updates := Updates + 1;
      end loop;

      if Acc.microseconds >= Fixed_Dt then
         Acc.microseconds := Acc.microseconds mod Fixed_Dt;
      end if;

      Alpha := Float (Acc.microseconds) / Float (Fixed_Dt);

      Update (Dt, Alpha);
   end loop;
end Armistrage;

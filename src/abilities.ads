package Abilities is
   type Target_Kind is (Self, Ally, Enemy);
   type Trigger_Kind is (BattleStart, Attack, Hurt, Kill, Die, Appear, Move);
   type Trigger_Order is (Before, During, After);
   type Action_Kind is
     (Damage, GiveStrength, ReduceStrength, Jump, Push, Summon, Kill);

   type Ability (Trigger : Trigger_Kind) is record
      Action        : Action_Kind;
      Action_Target : Target_Kind;
      case Trigger is
         when BattleStart =>
            null;

         when others =>
            Trigger_Target : Target_Kind;
      end case;
   end record;
end Abilities;

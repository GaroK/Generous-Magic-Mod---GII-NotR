META
{
    Engine = G1, G2A;
    Parser = Game;
};

class C_Trigger
{
    var int delay;
    var int enabled;
    var int aivariables[16];
};

var C_Trigger mana_regen_controller;

const int MANA_PER_SEC = 5;
const int TICS_PER_SEC = 1;

func int Regen_mana()
{
    var int adding; adding = ((hero.attribute[ATR_MANA_MAX] * MANA_PER_SEC)/100)/TICS_PER_SEC;
    if adding < 1 {
        adding = 1;
    };
    hero.attribute[ATR_MANA] += adding;
    if hero.attribute[ATR_MANA] >= hero.attribute[ATR_MANA_MAX] {
        hero.attribute[ATR_MANA] = hero.attribute[ATR_MANA_MAX];
    };
    return LOOP_CONTINUE;
};

func void Mana_regen_handler(var int enabled) {
    if enabled {
        mana_regen_controller = AI_StartTriggerScript("Regen_mana", 1000/TICS_PER_SEC);
    } else {
        mana_regen_controller.enabled = FALSE;
    };
};

instance Regen_ring(C_Item)
{
  name        = NAME_Ring;

  mainflag    = ITEM_KAT_MAGIC;
  flags       = ITEM_RING;

test G1 {
  visual      = "ItMi_Ring_01.3ds";
} else {
  visual      = "ItRi_Prot_Fire_02.3ds";
};
  visual_skin = 0;
  material    = MAT_METAL;

  on_equip    = Equip_Regen_ring;
  on_unequip  = UnEquip_Regen_ring;

  value       = 200;

  description = "Ring of mana regen";
  text[0]     = "";
  text[1]     = Str_format("Provides %i regeneration per second", MANA_PER_SEC);
  text[2]     = "";
  text[3]     = NAME_Bonus_Mana;          count[3] = 0;
  text[4]     = "";
  text[5]     = NAME_Value;               count[5] = value;
};

func void Equip_Regen_ring()
{
    self.attribute[ATR_MANA_MAX] += 10;
    Mana_regen_handler(true);
};

func void UnEquip_Regen_ring()
{
    self.attribute[ATR_MANA_MAX] -= 10;
    Mana_regen_handler(false);
};

instance PC_Hero(C_NPC) {
    PC_Hero_old();
    CreateInvItem(self, Regen_ring);     
};

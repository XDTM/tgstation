
#define DISEASE_LIMIT		1
#define VIRUS_SYMPTOM_LIMIT	6
#define VIRUS_TRAIT_LIMIT	6

//Disease Flags
#define CURABLE		(1<<0)
#define CAN_CARRY	(1<<1)
#define CAN_RESIST	(1<<2)

//Spread Flags
#define DISEASE_SPREAD_SPECIAL			(1<<0)
#define DISEASE_SPREAD_NON_CONTAGIOUS	(1<<1)
#define DISEASE_SPREAD_BLOOD			(1<<2)
#define DISEASE_SPREAD_CONTACT_FLUIDS	(1<<3)
#define DISEASE_SPREAD_CONTACT_SKIN 	(1<<4)
#define DISEASE_SPREAD_AIRBORNE			(1<<5)

//Mutator Defines (Effectively traits)
#define DISEASE_MUTATOR_ALPHA		"alpha"		//mild effects, usually a small +1 to the symptom.
#define DISEASE_MUTATOR_BETA		"beta"		//medium level effects, an addition to the symptom but still doesn't stray far from its core concept.
#define DISEASE_MUTATOR_GAMMA		"gamma"		//high level effects, adds a new aspect to the symptom which can range up to stuns and temporary debuffs.
#define DISEASE_MUTATOR_DELTA		"delta"		//very high level effects, adds a new aspect to the symptom which generally is permanent or lasts until cured.
#define DISEASE_MUTATOR_EPSILON		"epsilon"	//high threat effects: gives a symptom the potential to kill
#define DISEASE_MUTATOR_THETA		"theta"		//weird stuff: interaction with magic, quantum or bluespace is activated by this mutator

//Visibility Traits
#define DISEASE_HIDDEN_SCANNER	"disease_hidden_scanner"
#define DISEASE_HIDDEN_HUD		"disease_hidden_hud"

//Severity Defines
#define DISEASE_SEVERITY_POSITIVE	"Positive"  //Diseases that buff, heal, or at least do nothing at all
#define DISEASE_SEVERITY_NONTHREAT	"Harmless"  //Diseases that may have annoying effects, but nothing disruptive (sneezing)
#define DISEASE_SEVERITY_MINOR		"Minor"	    //Diseases that can annoy in concrete ways (dizziness)
#define DISEASE_SEVERITY_MEDIUM		"Medium"    //Diseases that can do minor harm, or severe annoyance (vomit)
#define DISEASE_SEVERITY_HARMFUL	"Harmful"   //Diseases that can do significant harm, or severe disruption (brainrot)
#define DISEASE_SEVERITY_DANGEROUS 	"Dangerous" //Diseases that can kill or maim if left untreated (flesh eating, blindness)
#define DISEASE_SEVERITY_BIOHAZARD	"BIOHAZARD" //Diseases that can quickly kill an unprepared victim (fungal tb, gbs)

//Property class defines
#define DISEASE_CLASS_NONE "None"
#define DISEASE_CLASS_STATS "Stats"

//Misc Flags
#define DISEASE_ABSTRACT 		"disease_abstract"		//Diseases with this trait aren't "real" diseases, and won't transfer to blood or be spread in any way
#define DISEASE_PROCESS_DEAD	"disease_proc_dead"		//Keeps processing while the host is dead

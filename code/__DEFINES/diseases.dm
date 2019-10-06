
#define DISEASE_LIMIT		1

#define DISEASE_FLUID_SPREAD_COEFF 1
#define DISEASE_CONTACT_SPREAD_COEFF 0.75
#define DISEASE_AIRBORNE_SPREAD_COEFF 0.50

//Disease Flags
#define CURABLE		(1<<0)
#define CAN_CARRY	(1<<1)

//Spread Flags
#define DISEASE_SPREAD_BLOOD			"disease_spread_blood"	//Allows transfer of disease via blood injection
#define DISEASE_SPREAD_CONTACT_FLUIDS	"disease_spread_fluids"	//Allows transfer of disease via contact with body fluids (vomit, blood)
#define DISEASE_SPREAD_CONTACT_SKIN 	"disease_spread_skin"	//Allows transfer of disease via skin contact (e.g. when bumping into each other)
#define DISEASE_SPREAD_AIRBORNE			"disease_spread_air"	//Allows transfer of disease via air
#define DISEASE_ABSTRACT 				"disease_abstract"		//Diseases with this trait are not "real" diseases
#define DISEASE_FIXED_HOST				"disease_fixed_host"	//Prevents the disease from spreading from one host to others, although it can still be given from a sample. 


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
#define DISEASE_PROCESS_DEAD	"disease_proc_dead"		//Keeps processing while the host is dead
#define DISEASE_NO_IMMUNITY		"disease_no_immunity"	//The disease does not give immunity when cured (still does if naturally immune)

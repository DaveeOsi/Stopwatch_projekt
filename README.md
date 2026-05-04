# Stopwatch_projekt



Tento projekt implementuje pokročilé digitální stopky s funkcí měření kol (Lap) a historií měření na vývojové desce Nexys A7-50T. Systém je navržen v jazyce VHDL

Hlavní funkce
Měření času: Přesnost na setiny sekundy s maximálním rozsahem 99:99.

Měření kol (Lap): Možnost změřit aktuální čas kola, který se uloží do vnitřní paměti, přičemž běžící časomíra se pro nové kolo automaticky vynuluje.

Historie měření: Možnost procházet až 8 naposledy uložených časů kol.

Ovládání 
K ovládání stopek se využívá 5 tlačítek v křížovém uspořádání na desce Nexys A7:
Tlačítko	Funkce	Popis
BTNC (Střed)	START	Spustí hlavní časomíru.
BTNL (Vlevo)	ZMĚŘENÍ ČASU	Uloží čas aktuálního kola do historie a vyresetuje čítač pro nové kolo.
BTNR (Vpravo)	KONEC	Zastaví běžící časomíru.
BTND (Dole)	KONTROLA	Přepne do režimu historie a listuje mezi uloženými časy kol.
BTNU (Nahoře)	RESET	
Globální synchronní reset: vynuluje čas a kompletně vymaže paměť kol.

Popis simulace:
na obrazku simulace mužeme vidět, jak nám nahoře v clk, počítáme čas, který uběhl. Řádek s_rst ukazuje tlačítko pro vymazání uložených časů. Řádek s_btn_start ukazuje tlačítko pro start časovače. Řádek s_btn_lap ukazuje, že když zmačkneme tlačitko pro měření času, čas se uloži. Řádek s_btn_stop ukazuje tlačitko, ktere ukončí měření času. Řádek s_btn_view ukazuje, že když ho zmačkneme, postupně ukazuje jednotlivá uložená kola. Řádky s_data a s_lap_num ukazují data která jsme uložili a poček měření. 

![description](Simulace_last.png)

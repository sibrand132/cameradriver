;;import wymaganych bibliotek i plikow
(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.*)
(load-package FuzzyFunctions)
(batch fakty.clp)


;;deklaracja zmiennych rozmytych
(defglobal ?*NatOswFvar* = (new FuzzyVariable "natezenie_oswietlenia" 0.0001 25000 "lx"))
(defglobal ?*GlebOstrFvar* = (new FuzzyVariable "glebia_ostrosci" -1 1 "stopien"))
(defglobal ?*PredPorFvar* = (new FuzzyVariable "predkosc_poruszania" 0 200 "km/h"))
(defglobal ?*MigFvar* = (new FuzzyVariable "migawka" 0.0005 1 "s"))
(defglobal ?*ISOFvar* = (new FuzzyVariable "swiatloczulosc" 100 1600 "ISO"))
(defglobal ?*PrzysFvar* = (new FuzzyVariable "przyslona" 3.2 6.9 "f/"))


(defglobal ?*tempus* = 0)


;;regula startowa inicjujaca proces wnioskowania rozmytego
(defrule init 
 (declare (salience 100))
=>
 (import nrc.fuzzy.*)
 (load-package nrc.fuzzy.jess.FuzzyFunctions)

(bind ?rlf (new RightLinearFunction)) (bind ?llf (new LeftLinearFunction))
    
	
;;rozmywanie na przedzialy kazdej zmiennej

;;natezenie oswietlenia
(?*NatOswFvar* addTerm "ciemno" (new TrapezoidFuzzySet 0.0001 0.0001 30 45 ))
(?*NatOswFvar* addTerm "swiatlo_sztuczne" (new TrapezoidFuzzySet 30 50 80 90))
(?*NatOswFvar* addTerm "pochmurno" (new TrapezoidFuzzySet 80 100 500 10000))
(?*NatOswFvar* addTerm "slonecznie" (new TrapezoidFuzzySet 8000 10000 25000 25000))


;;glebia ostrosci
(?*GlebOstrFvar* addTerm "mala" (new TriangleFuzzySet -1 -1 0))
(?*GlebOstrFvar* addTerm "srednia" (new TriangleFuzzySet -1 0 1))
(?*GlebOstrFvar* addTerm "duza" (new TriangleFuzzySet 0 1 1))
	
;;predkosc poruszania
(?*PredPorFvar* addTerm "chod" (new TrapezoidFuzzySet 0 0 7.5 10))
(?*PredPorFvar* addTerm "srednia" (new TrapezoidFuzzySet 8 20 30 50))
(?*PredPorFvar* addTerm "szybka" (new TrapezoidFuzzySet 40 50 60 70))
(?*PredPorFvar* addTerm "b_szybka" (new TrapezoidFuzzySet 65 100 200 200))

;;migawka
(?*MigFvar* addTerm "krotki" (new TrapezoidFuzzySet 0.0005 0.0005 0.001 0.002))
(?*MigFvar* addTerm "sredni" (new TrapezoidFuzzySet 0.00125 0.002 0.005 0.01))
(?*MigFvar* addTerm "dlugi" (new TrapezoidFuzzySet 0.005 0.01 0.05 0.1))
(?*MigFvar* addTerm "b_dlugi" (new TrapezoidFuzzySet 0.04 0.5 1 1))

;;swiatloczulosc
(?*ISOFvar* addTerm "mala" (new TrapezoidFuzzySet 100 100 400 600))
(?*ISOFvar* addTerm "srednia" (new TrapezoidFuzzySet 400 600 900 1100))
(?*ISOFvar* addTerm "duza" (new TrapezoidFuzzySet 900 1100 1600 1600))

;;przyslona
(?*PrzysFvar* addTerm "duza" (new TrapezoidFuzzySet 3.2 3.2 5 5.4))
(?*PrzysFvar* addTerm "srednia" (new TrapezoidFuzzySet 5 5.5 5.8 6))
(?*PrzysFvar* addTerm "mala" (new TrapezoidFuzzySet 5.8 6.2 6.9 6.9))


(printout file "" crlf)
(printout file "System ekspertowy - logika rozmyta " crlf) 
(printout file "" crlf)
(printout file "Sterownik rozmyty dla aparatu" crlf) 
(printout file "" crlf)
(printout file "Jako wynik otrzymujemy parametry w jakich zostanie zrobione zdjecie " crlf) 
(printout file "" crlf)




 

;;po wczytaniu z pliku dane wejsciowe zapisywane sa do odpowiedniej formy faktu w celu przeprowadzenia procesu wnioskowania
;;natezenie oswietlenia
(assert (crispNatOsw ?*zmNatOsw*))
(assert (NatOsw (new FuzzyValue ?*NatOswFvar* (new TrapezoidFuzzySet ?*zmNatOsw* ?*zmNatOsw* ?*zmNatOsw* ?*zmNatOsw*))))

;;glebia ostrosci
(assert (crispGlebOstr ?*zmGlebOstr*))
(assert (GlebOstr (new FuzzyValue ?*GlebOstrFvar* (new TriangleFuzzySet ?*zmGlebOstr* ?*zmGlebOstr* ?*zmGlebOstr*))))

;;predkosc poruszania
(assert (crispPredPor ?*zmPredPor*))
(assert (PredPor (new FuzzyValue ?*PredPorFvar* (new TrapezoidFuzzySet ?*zmPredPor* ?*zmPredPor* ?*zmPredPor* ?*zmPredPor*))))

)

(defrule regula1
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))


(defrule regula2
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula3
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula4
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula5
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))


(defrule regula6
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))

=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))


(defrule regula7
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))


(defrule regula8
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula9
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula10
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula11
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula12
(NatOsw ?no&:(fuzzy-match ?no "ciemno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "duza")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula13
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula14
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula15
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula16
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula17
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula18
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula19
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula20
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula21
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "b_dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula22
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula23
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula24
(NatOsw ?no&:(fuzzy-match ?no "swiatlo_sztuczne"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula25
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula26
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula27
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula28
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula29
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula30
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula31
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula32
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula33
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula34
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "dlugi")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula35
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula36
(NatOsw ?no&:(fuzzy-match ?no "pochmurno"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "srednia")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula37
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula38
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula39
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula40
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "mala"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "duza"))))

(defrule regula41
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula42
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula43
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula44
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "srednia"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "srednia"))))

(defrule regula45
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "chod"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula46
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "srednia"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "sredni")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula47
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))

(defrule regula48
(NatOsw ?no&:(fuzzy-match ?no "slonecznie"))
(GlebOstr ?go&:(fuzzy-match ?go "duza"))
(PredPor ?pp&:(fuzzy-match ?pp "b_szybka"))
=>
(bind ?*tempus* 1)
(assert (Migawka (new FuzzyValue ?*MigFvar* "krotki")))
(assert (Swiatloczulosc (new FuzzyValue ?*ISOFvar* "mala")))
(assert (Przyslona (new FuzzyValue ?*PrzysFvar* "mala"))))


;;regula odpowiadajaca za proces wnioskowania rozmytego, nastepuje tutaj defuzyfikacja, wnioskowanie, wyostrzanie, zapisanie wynikow do pliku
(defrule control
(declare (salience -100))

?nat_osw <- (crispNatOsw ?no)
?gleb_ostr <- (crispGlebOstr ?go)
?pred_por <- (crispPredPor ?pp)


?mig <- (Migawka ?fuzzyMigawka)
?swiatlo <- (Swiatloczulosc ?fuzzyISO)
?przys <- (Przyslona ?fuzzyPrzyslona)


=>
   
    (bind ?crispMigawka (?fuzzyMigawka momentDefuzzify))
    (bind ?crispISO (?fuzzyISO momentDefuzzify))
    (bind ?crispPrzyslona (?fuzzyPrzyslona momentDefuzzify))
    
    
	;;wyswietlanie wynikow wnioskowania w konsoli
    (printout file "" crlf)
    (printout file "Dla natezenia swiatla = " ?no " , glebi ostrosci = " ?go " oraz predkosci poruszania = " ?pp crlf)
      
    (bind ?zmienna1 (* ?crispMigawka 1))
    (bind ?zmienna2 (* ?crispISO 1))
    (bind ?zmienna3 (* ?crispPrzyslona 1))
	
    
    
    ;;zaokraglanie wynikow do 2 miejsc po przecinku
   (bind ?aaa (round  (* ?zmienna1 10000))) 
   (bind ?aaaa (/ ?aaa 10000))
   
   (bind ?bbb (round  (* ?zmienna2 100))) 
   (bind ?bbbb (/ ?bbb 100))
   
   (bind ?ccc (round  (* ?zmienna3 100)))
   (bind ?cccc (/ ?ccc 100))
   
    
	;;wyswietlanie wynikow 
    (printout file "" crlf)
    (printout file "Ustawiono nastepujace parametry:" crlf)
    (printout file "" crlf)
    (printout file "Czas otwarcia migawki = " ?aaaa " s" crlf)
    (printout file "Swiatloczulosc = " ?bbbb " ISO" crlf)
    (printout file "Wielosc przyslony = f/" ?cccc  crlf)
    
    )


	
	
;;zaladowanie faktow do pamieci roboczej jess i uruchomienie mechanizmu wnioskowania	
(reset)
(run)
globals [
  initial-trees   ;; how many trees (green patches) we started with
  burned-trees    ;; how many have burned so far
]

breed [fires fire]    ;; bright red turtles -- the leading edge of the fire
breed [embers ember]  ;; turtles gradually fading from red to near black

patches-own
[ tree?    ;; this is used to "unburn" the forest so that different configurations of fire-breaks
           ;; can be tried on the same forest
  break?
  zone2?

  ] ;; this is where the firebreaks have been drawn

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  clear-all
  set-default-shape turtles "square"
  ;; make some green trees
  ask patches with [(random-float 100) < Walddichte]
    [ set pcolor green
      set tree? true ]
  ; ignite-forest-on-the-left - the user has to now do this explicitly using a button
  ;; set tree counts
  set initial-trees count patches with [is-tree? pcolor]
  set burned-trees 0
  reset-ticks
end

to go
  if not any? turtles  ;; either fires or embers
    [ stop ]
  ask fires[
    if Wind?[
        set heading Wind-Richtung fd Windgeschwindigeit * 0.25
     rt random Wind-boeigkeit
     lt random Wind-boeigkeit
        ]

   ask neighbors4 with [is-tree? pcolor]
        [ ignite ]
      set breed embers ]
     fade-embers
  tick
end

to-report is-tree? [colour]
;; Reports true if the colour is a shade of green.

  report ((colour > 50) and (colour < 60)) or ((colour > 60) and (colour < 70))
      or ((colour > 0) and (colour < 9))
end

;; creates the fire turtles
to ignite  ;; patch procedure
  sprout-fires 1
    [ set color red ]
  set pcolor black
  set burned-trees burned-trees + 1
end

to ignite-forest
;; light a fire where the user says to

  if (mouse-down?)
    [
      ask patch mouse-xcor mouse-ycor
      [
        sprout-fires 1
        [
          set color red
          set burned-trees burned-trees + 1
          ask patches in-cone 2 360
          [ sprout-fires 1
            [
              set color red
              set burned-trees burned-trees + 1
            ]
          ]
        ]
        display
      ]
    ]
end

to ignite-forest-on-the-left
;; make a column of burning trees on the left
  ask patches with [pxcor = min-pxcor]
    [ ignite ]
end

;; achieve fading color effect for the fire as it burns
to fade-embers
  let Feuer-zu-Glut 0.05
  ask embers
    [ set color color - Feuer-zu-Glut  ;; make red darker
      if color < red - 3.5     ;; are we almost at black?
        [ set pcolor color
          die ] ]
end

to draw-forest
;; draw some forest
  if (mouse-down?)
    [
      ask patch mouse-xcor mouse-ycor
      [
        sprout 1
        [
          ask patches in-cone 3 360
          [ set pcolor green
            set tree? true
          ]
          die
        ]
        display
      ]
    ]
end

to import-forest
;; Imports the forest from an image.

  ask patches
  [ set pcolor white
    set tree? false ]


  ask patches with [is-tree? pcolor]
  [ set tree? true ]
end

;; to draw-firebreak
;; draw a firebreak in the forest
;;   if (mouse-down?)
;;     [
;;       ask patch mouse-xcor mouse-ycor
;;       [
;;         sprout 1
;;         [
;;           ask patches in-cone Breite-Brandschneise 360
;;           [ set pcolor 31 ; very dark brown
;;             set break? true
;;           ]
;;           die
;;         ]
;;         display
;;       ]
;;     ]
;; end

to remove-firebreaks
;; removes any firebreaks that have been drawn in the environment

  ask patches with [break? = true]
  [ ifelse (tree? = true)
      [ set pcolor green ]
      [ set pcolor black ]
    set break? false
  ]
end

to unburn-forest
;; to reset the simulation to the forest when the setup button was pressed,
;; but keeping the user-drawn fire-breaks
  ask patches with [tree? = true]
  [ set pcolor green ]
  set burned-trees 0
end

to burn-all-the-forest
;; uses a random algorithm to burn all the forest.

  let this-patch one-of patches with [is-tree? pcolor]
  if (this-patch != nobody)
  [
    ask this-patch
    [
      ignite
      display
      ask fires
        [ ask neighbors4 with [is-tree? pcolor]
            [ ignite ]
          set breed embers ]
      fade-embers
      display
    ]
  ]
end


; Copyright 1997 Uri Wilensky. All rights reserved.
; The full copyright notice is in the Information tab.

; Extended code used for this model: Copyright 2010 Bill Teahan.
; Extended code used for this model: Copyright 2021 MeKo.
@#$#@#$#@
GRAPHICS-WINDOW
254
24
764
535
-1
-1
2.0
1
10
1
1
1
0
0
0
1
-125
125
-125
125
1
1
1
ticks
30.0

MONITOR
770
130
940
175
Anteil Wald [%] verbrannt
(burned-trees / initial-trees)\n* 100
1
1
11

SLIDER
25
120
240
153
Walddichte
Walddichte
0
100
75.0
5
1
%
HORIZONTAL

BUTTON
870
25
939
70
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
770
25
840
70
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
770
75
940
125
Experiment wiederholen
unburn-forest
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
25
25
240
58
Waldbrandlinie starten
ignite-forest-on-the-left
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
25
60
240
93
Waldbrand-Startpunkte
ignite-forest
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
30
200
120
233
Wind?
Wind?
1
1
-1000

SLIDER
30
235
245
268
Wind-Richtung
Wind-Richtung
0
360
225.0
45
1
Grad
HORIZONTAL

SLIDER
30
270
245
303
Windgeschwindigeit
Windgeschwindigeit
0
12
2.5
1
1
Beaufort
HORIZONTAL

SLIDER
30
305
245
338
Wind-Boeigkeit
Wind-Boeigkeit
0
360
90.0
10
1
Grad
HORIZONTAL

@#$#@#$#@
## Was macht das Modell?
Das Modell Fire-Simulation-1 ist eine Erweiterung, des ursprünglich von Uri Wilensky entwickelten Feuermodells. Das Referenzmoidell ist in der NetLogo Modellbibliothek enthalten. Es simuliert die Feuer-Ausbreitung in Fläche mit nach definiertem prozentualen Anteil an der Gasamt zufaellig angeordneten  Waldpatches. Zusaetzlich bietet es eine Nutzerschnittstelle die es ermoeglicht, Brandschneisen, zusaetzliche Waldpatches und initiale Brand-Startpunkte interkativ hinzuzufuegen bzw. zu loeschen.

## Wie funktioniert es?
Mit der Schaltflaeche Setup wird ein Zufallswald in der angegebenen Dichte (Prozent an der Gesamtflaeche) erstellt.
Der Benutzer kann manuell an verschiedenen Positionen Braende ausloesen. Hierzu aktiviert er die Schaltflaeche _**Waldbrand-Startpunkte**_ um dann jeweils an der gewuenschten Position mit Maustklick eine initiale Brandposition hinzuzufügen (Achtung: Zum Schluss erneut die Schaltflaeche anklicken um den Edit-Modus zu deaktivieren). Alternativ das Feuer auch an einer durchgehenden vertikalen Linie auf der linken Seite der Umgebung initialisiert werden (**Waldrandlinie starten**). Mit _**Wald zeichnen**_ können zusaetzliche Flaechen als Wald gezeichnet werden, und schliesslich koennen Brandschneisen (**Brandschneise zeichnen** gezeichnet  werden.

Ohne Windeinfluss breitet sich das Feuer von den Entzuendungspunkten aus in vier Richtungen (N, S, E, W) auf benachbarte Waldflaechen aus. Die Ausbreitung des Feuers haengt also von der Verfügbarkeit von benachbartem Wald ab. Sobald ein Feuer-Agent seine(n) naechsten Baum-Nachbarn entzuendet hat (falls es einen/welche gibt), verwandelt es sich in einen _**Glut-Patch**, dessen Farbe langsam von rot zu schwarz verblasst (abhaengig von dem Wert des Schieberegler fuer die Intensitaet des Feuer. Zuletzt verloescht es.


## Wie kann es benutzt werden?
* Aktivieren Sie als erstes die _**Setup**_ Schaltfläche. Es wird ein Wald mit zufaellig verteilten Baum-Patches erstellt, deren Wahrscheinlichkeitshäufikeit  mit dem Schieberegler _**Walddichte**_ festgelegt wird.
* Um ein Feuer an einem bestimmten Punkt zu entfachen, muessen entweder mithilfe der Schaltflaeche _**Waldbrand-Startpunkte**_ und/oder _**Waldbrandlinie starten**_ initiale Brandherde definiert werden.  
Verbrannter Wald kann mit der Schaltflaeche _**Experiment wiederherstellen**_ im Ausgangszustand wiederhergestellt werden. Das bedeutet, dass eine Simulation desselben Waldes mehrmals mit unterschiedlichen Brandschneisen und Ausbruchorten durchgefuehrt werden kann.
* Das Modell wird durch aktivieren der  _**Go**_ Schaltfleache gestartet.

## Die Nutzerschnittstelle

Die Schaltflaechen der Schnittstelle sind wie folgt definiert:

*  _**Setup:**_ Damit wird die Simulation vollstaendig zurueckgesetzt und ein Zufallswald erstellt.
*  _**Go**_: Damit wird die Simulation gestartet. Wenn in der Umgebung Brandherde platziert wurden, breitet sich das Feuer auf benachbarte Baeume aus.
* _**Experiment wiederherstellen**_: Dies stellt den Zustand des Waldes wieder her, wie er vor dem Abbrennen der Baeume war.
* _**Waldbrand-Startpunkte**_: Damit wird an der Stelle, an der mit der Maus geklickt wird, ein Zuendpunkt gesetzt, von dem aus das Feuer zu brennen beginnt. Wenn Sie die Maus gedrueckt halten, werden mehrere sich ueberlappende Zuendpunkte gezeichnet. 
* _**Waldbrandlinie starten**_: Eine vertikale Linie des Feuers wird von der linken Seite der Umgebung aus entzuendet.

Der Monitor und die Schieberegler sind wie folgt definiert:

* _**Anteil Wald verbrannt:**_: Dies ist der Prozentsatz der Wald-Patches am Gesamtwald, die verbrannt sind.
* _**Wald-Dichte**_: Dies ist die Anteil in Prozent des raeumlich zufaellig generierten Waldes an der Gesamtflaeche.
*  _**Wind?**_: Schalter fuer das Aktivieren der Schieberegler von Windrichtung/Windgeschwindigkeitund Wind-Boeigkeit
*  _**Windrichtung**_: Festlegen der Hauptwindrichtung in Grad
*  _**Windgeschwindigkeit**_: Festlegen der Windgeschwindigkeit
*  _**Wind-Boeigkeit**_: Festlegen der zufaelligen Abweichung von der Hauptwindrichtung in Grad


Der Ablauf einer Simulation erfolgt also quasi von **oben** nach **unten**. -**Mit Experiment wiederherstellen**_ kann das Ausgansszenario (mit Ausnahme der initialen Feuerpositionen) wiederhergestellt werden.


## Moegliche Fragen
* Wie viel Wald brennt bei welchen Dichteeinstellungen? 
* Welcher Schwellenwert muss bei der Dichteeinstellung erreicht werden, damit fast der gesamte Wald verbrennt?
* Verbrennen die gleichen Teile des Waldes wenn das Experiment wiederholt wird? Wenn ja, warum?
* Scheinbar begwegen sich die turtles nicht. Wie koennen Sie ueberpruefen ob das stimmt? Trotzdem bewegt sich das Feuer. Wie kommt das?
* Welche minimale Anordnung von Brandschneisen kann das Feuer am besten eindaemmen.



## Quellen
Breadth First Search in den Modellen Searching Mazes, Missionaries and Cannibals und Searching von Kevin Bacon.
Urspruengliches Fire-Modell und fuer die NetLogo-Software anzugeben: - Wilensky, U. (1997). NetLogo Fire-Modell. http://ccl.northwestern.edu/netlogo/models/Fire. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL. - Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Zentrum fuer vernetztes Lernen und computergestuetztes Modellieren, Northwestern University, Evanston, IL.
In anderen Publikationen bitte verwenden: - Copyright 1997 Uri Wilensky. Alle Rechte vorbehalten. Siehe http://ccl.northwestern.edu/netlogo/models/Fire fuer die Nutzungsbestimmungen.
Erweiterung des Modells wurde von Bill Teahan geschrieben. Um auf dieses Modell in Publikationen zu verweisen, verwenden Sie bitte:
Firebreak NetLogo-Modell. Teahan, W. J. (2010). Kuenstliche Intelligenz. Ventus Publishing Aps
Implementierung des Windes und der HAussimulation sowie weitere Anpassungen und Uebersetzung: Rieke Ammoneit, Carina Peter und Chris Reudenbach, Medienkompetenz in der Geographie (2021)

##  COPYRIGHT-HINWEIS
Urheberrecht 1997 Uri Wilensky. Alle Rechte vorbehalten.
Die Erlaubnis, dieses Modell zu verwenden, zu modifizieren oder weiterzugeben, wird hiermit erteilt, vorausgesetzt, dass die beiden folgenden Bedingungen befolgt werden: a) dieser Copyright-Hinweis ist enthalten. b) dieses Modell wird nicht ohne Erlaubnis von Uri Wilensky zu Gewinnzwecken weitergegeben. Wenden Sie sich an Uri Wilensky, um geeignete Lizenzen fuer die Weiterverbreitung zu Erwerbszwecken zu erhalten.
Dieses Modell wurde im Rahmen des Projekts erstellt: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML). Das Projekt bedankt sich fuer die Unterstuetzung durch die National Science Foundation (Applications of Advanced Technologies Program) - Zuschussnummern RED #9552950 und REC #9632612.
Dieses Modell wurde am MIT Media Lab mit CM StarLogo entwickelt. Siehe Resnick, M. (1994) "Turtles, Termites and Traffic Jams: Explorations in Massively Parallel Microworlds". Cambridge, MA: MIT Press. Angepasst an StarLogoT, 1997, als Teil des Connected Mathematics Project.
Dieses Modell wurde im Rahmen des Projekts in NetLogo umgewandelt: PARTIZIPATIVE SIMULATIONEN: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLAssROOMS und/oder INTEGRATED SIMULATION AND MODELING ENVIRONMENT. Das Projekt dankt der National Science Foundation (REPP- und ROLE-Programme) fuer ihre Unterstüuezung - Foerderungsnummern REC #9814682 und REC-0126227. Konvertiert von StarLogoT zu NetLogo, 2001.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
set density 60.0
setup
repeat 180 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="Wind?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Windgeschwindigeit">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Walddichte">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Breite-Brandschneise">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Wind-Boeigkeit">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Feuer-zu-Glut">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Wind-Richtung">
      <value value="181"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@

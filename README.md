# Where is my Ride?

## Zusammenfassung

### Zielsetzung
Entwicklung einer Applikation, die es ermöglicht, den Ort und ein Foto eines geparkten Fahrzeugs zu speichern, zu teilen und wieder zu laden. Überdies soll der Ort auf einer Karte dargestellt werden und feinjustierbar sein.

### Weitere Ziele
Implementierung eines Mehrbenutzersystems, das zugleich die Verwaltung mehrerer Fahrzeuge ermöglicht. Route zurück zum Auto innerhalb der Anwendung. Statusmitteilung an andere Geräte und Synchronisation von Fahrzeugen. Parkzeiteinstellung und Alarm in verschiedenen Varianten: Zielzeit, Dauer, Messung.

## Details

### Feature Liste
* aktuellen Ort bestimmen
* Ort in Karte anzeigen
* Ort verschiebbar machen
* Foto des Fahrzeugs aufnehmen
* Informationen teilen
* Informationen speichern
* Informationen laden
* mehrere Fahrzeuge verwalten
* Mehrbenutzersystem (iCloud)
* Route zurück in Maps
* *Route zurück in der Anwendung selbst*
* Push-Notifications und Synchronisation
* Parkzeiteinstellungen inkl. Alarm
    * Zielzeit
    * Dauer
    * Fortlaufend
    * Alarm, basierend auf Fußweg


## Wichtige Aufgaben

### Beseitige Memory-Leak
**Beschreibung:**
Wenn vom `VehicleDetailView` in den `VehicleListView` zurückgewechselt wird, werden anscheinend bestimmte Ressourcen nicht freigegeben, beim erneuten wechseln in den `VehicleDetailView` jedoch erneut und zusätzlich alloziert. Dies führt zu einem hohen Speicherbedarf, insbesondere dann, wenn ein angefordertes `WIMRVehicleModel`-Objekt Fotos enthält.

### Ermögliche Entfernen von Fotos aus `WIMRVehicleModel`-Objekten
**Beschreibung:**
Bisher ist es nicht möglich, Fotos aus einem `WIMRVehicleModel`-Objekt Fotos zu löschen. Außerdem ist es nicht möglich, gezielt ein bestimmtes Foto anzuwählen. Hierzu sollte der `WIMRPhotoViewController` angepasst werden.
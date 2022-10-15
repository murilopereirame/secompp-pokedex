import 'package:pokedex_secompp/utils.dart';

class Evolution {
  int pokemonId;
  List<String> trigger;
  List<String> triggerTarget = [];
  List<Evolution> evolvesTo = [];
  String pokemonName;  

  Evolution(this.pokemonId, this.trigger, this.pokemonName);

  void buildTriggerTarget(List<dynamic> evoDetails) {    
    for(Map<String, dynamic> details in evoDetails) {
      List<String> triggers = [];
      
      if(details["gender"] != null) {
        triggers.add(capitalizeWords(details['gender']['name'], '-', replace: ' '));
      } 
      
      if(details["held_item"] != null) {
        triggers.add("Holding ${capitalizeWords(details['held_item']['name'], '-', replace: ' ')}");
      }

      if(details["item"] != null) {
        triggers.add("${capitalizeWords(details['item']['name'], '-', replace: ' ')}");
      }

      if(details["known_move"] != null) {
        triggers.add("Know ${capitalizeWords(details['known_move']['name'], '-', replace: ' ')} move");
      }

      if(details["known_move_type"] != null) {
        triggers.add("Knows move of type ${capitalizeWords(details['known_move_type']['name'], '-', replace: ' ')}");
      }

      if(details["location"] != null) {
        triggers.add("At ${capitalizeWords(details['location']['name'], '-', replace: ' ')}");
      }

      if(details["min_affection"] != null) {
        triggers.add("Affection ${details['min_affection']}");
      }

      if(details["min_beauty"] != null) {
        triggers.add("Beauty ${details['min_beauty']}");
      }

      if(details["min_happiness"] != null) {
        triggers.add("Happiness ${details['min_happiness']}");
      }

      if(details["min_level"] != null) {
        triggers.add("Level ${details['min_level']}");
      }

      if(details["needs_overworld_rain"] != null && details["needs_overworld_rain"] == true) {
        triggers.add("Needs Overworld Rain");
      }

      if(details["party_species"] != null) {
        triggers.add("Party with ${capitalizeWords(details['party_species']['name'], '-', replace: ' ')}");
      }

      if(details["party_type"] != null) {
        triggers.add("Party with ${capitalizeWords(details['party_type']['name'], '-', replace: ' ')}");
      }

      if(details["relative_physical_stats"] != null) {
        if(details["relative_physical_stats"].toString() == "1") {
          triggers.add("Attack > Defense");
        } else if(details["relative_physical_stats"].toString() == "-1") {
          triggers.add("Attack < Defense");
        } else {
          triggers.add("Attack = Defense");
        }      
      }

      if(details["time_of_day"] != null && details["time_of_day"] != "") {
        triggers.add("${details['time_of_day']}");
      }

      triggerTarget.add(triggers.join(" and ").trim());
    }
  }
}

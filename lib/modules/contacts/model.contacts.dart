import 'package:utm_vinculacion/modules/global/helpers.dart';

/// Creates a new model for a contact on the application
class Contact {
    Contact({
        this.id,
        this.title,
        this.description,
        this.phone,
	this.email,
	this.location,
	this.webpage
    }){
      this.id = this.id ?? generateID();
    }

    int id;
    String title;
    String description;
    String phone;
    String email;
    String location;
    String webpage;

    /// Creates a new contact. In this method [json] is the raw output of SQLite
    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        title: json["name"],
        description: json["description"],
        phone: json["phone"],
	email: json["email"],
	location: json["location"],
	webpage: json["webpage"]
    );

    /// Exports a new contact to save it to SQLite
    Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "description": description,
        "phone": phone,
	"email": email,
	"location": location,
	"webpage": webpage
    };
}

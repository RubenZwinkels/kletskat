package rzwinkels.kletskatapi.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;

import java.util.UUID;

@Entity(name = "Cat")
public class Cat {
    @Id
    @GeneratedValue
    private UUID id;
    @ManyToOne
    private CustomUser user;
    private String color;  // hex
    private String eyeColor; //hex
    private String name;
    private int bond; // op een schaal van 0-100
    private Personality personality;


    public Cat(){}

    public Cat(CustomUser user, String color, String eyeColor, String name, int bond, Personality personality) {
        this.user = user;
        this.color = color;
        this.eyeColor = eyeColor;
        this.name = name;
        this.bond = bond;
        this.personality = personality;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public CustomUser getUser() {
        return user;
    }

    public void setUser(CustomUser user) {
        this.user = user;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getEyeColor() {
        return eyeColor;
    }

    public void setEyeColor(String eyeColor) {
        this.eyeColor = eyeColor;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getBond() {
        return bond;
    }

    public void setBond(int bond) {
        this.bond = bond;
    }

    public Personality getPersonality() {
        return personality;
    }

    public void setPersonality(Personality personality) {
        this.personality = personality;
    }
}

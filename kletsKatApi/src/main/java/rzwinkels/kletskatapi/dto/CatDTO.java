package rzwinkels.kletskatapi.dto;

import rzwinkels.kletskatapi.model.Personality;

import java.util.UUID;

public class CatDTO {
    private String color; // hex
    private String eyeColor; // hex
    private String name;
    private int bond; // op een schaal van 0-100
    private Personality personality;

    public CatDTO(String color, String eyeColor, String name, int bond, Personality personality) {
        this.color = color;
        this.eyeColor = eyeColor;
        this.name = name;
        this.bond = bond;
        this.personality = personality;
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
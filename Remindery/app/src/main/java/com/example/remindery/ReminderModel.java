package com.example.remindery;

import java.time.LocalDateTime;

public class ReminderModel {

    private int id;
    private String title;
    private String time;
    private String description;
    private boolean isDone;
    private boolean isSelected;
    private String shortDesc;

    public ReminderModel(int id, String title, String time, String description, boolean isDone) {
        this.id = id;
        this.title = title;
        this.time = time;
        this.description = description;
        this.isDone = isDone;
    }
    public ReminderModel(int id, String title, String time, String description) {
        this.id = id;
        this.title = title;
        this.time = time;
        this.description = description;
    }
    public ReminderModel( String title, String time, String description) {

        this.title = title;
        this.time = time;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isDone() {
        return isDone;
    }

    public void setDone(boolean done) {
        isDone = done;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public String getShortDesc() {
        return shortDesc;
    }

    public void setShortDesc(String shortDesc) {
        this.shortDesc = shortDesc;
    }
}

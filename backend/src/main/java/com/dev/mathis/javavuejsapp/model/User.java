package com.dev.mathis.javavuejsapp.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import jakarta.persistence.Entity;

@Entity
@jakarta.persistence.Table(name = "USERS")
@Getter
@Setter
public class User {

    @jakarta.persistence.Id
    @Column(name = "USERNAME")
    private String username;

    @Column(name = "PASSWORD")
    private String password;

    public User() {}

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
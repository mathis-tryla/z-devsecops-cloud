package com.dev.mathis.javavuejsapp.model;

import lombok.Getter;
import lombok.Setter;

import java.util.Objects;

import javax.persistence.*;
import jakarta.persistence.Entity;

@Entity
@jakarta.persistence.Table(name = "USERS")
@Getter
@Setter
public class User {

    @jakarta.persistence.Id
    @GeneratedValue
    private Long id;

    /**
     * Username field relates to the username form input
     * where users can type their username or their email.
     * It is what makes the user unique.
     */
    //@jakarta.persistence.Id
    @Column(name = "USERNAME")
    private String username;

    @Column(name = "PASSWORD")
    private String password;

    public User() {}

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public boolean equals(User user) {
        if (this == user)
            return true;
        if (!(user instanceof User))
            return false;
        User u = (User) user;
        return Objects.equals(this.id, u.id) && Objects.equals(this.username, u.username)
            && Objects.equals(this.password, u.password);
    }
}
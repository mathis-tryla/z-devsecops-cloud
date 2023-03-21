package com.dev.mathis.javavuejsapp.controller;

import com.dev.mathis.javavuejsapp.model.User;
import com.dev.mathis.javavuejsapp.repository.UserRepository;
import com.dev.mathis.javavuejsapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:3000")
public class UserController {

    @Autowired
    UserService userService;


    @GetMapping("/hello")
    public String hello(){
        return "Hello spring boot vuejs app!";
    }

    @GetMapping("/users")
    Collection<User> getUsers() {
        return userService.getUsers();
    }

    @GetMapping("/users/{username}")
    User getUser(String username) {
        return userService.findUserByUsername(username);
    }

    @PostMapping("/users")
    User createUser(@RequestBody User newUser) {
        return userService.createUser(newUser);
    }

    /*@DeleteMapping("/users/{username}")
    void deleteUser(@PathVariable String username) {
        userService.deleteUserByUsername(username);
    }*/
}

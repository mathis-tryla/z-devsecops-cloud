package com.dev.mathis.javavuejsapp.service;

import com.dev.mathis.javavuejsapp.model.User;
import com.dev.mathis.javavuejsapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    //@Autowired
    private UserRepository userRepository;

    public List<User> getUsers() {
        return userRepository.findAll();
    }

    public User findUserByUsername(@PathVariable String username) { return userRepository.findByUsername(username); }

    public User createUser(@RequestBody User newUser) {
        return userRepository.save(newUser);
    }

    public Optional<User> getUser(@PathVariable Long id) {
        return userRepository.findById(id);
    }

    public void deleteUserByUsername(@PathVariable String username) {
        userRepository.deleteByUsername(username);
    }
}

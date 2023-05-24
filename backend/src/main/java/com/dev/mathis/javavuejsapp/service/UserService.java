package com.dev.mathis.javavuejsapp.service;

import com.dev.mathis.javavuejsapp.model.User;
import com.dev.mathis.javavuejsapp.repository.UserRepository;

import org.springframework.data.domain.Example;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private UserRepository userRepository;

    public UserService(UserRepository userRepository){
        this.userRepository = userRepository;
    }

    @Transactional
    public List<User> getUsers() {
        return userRepository.findAll();
    }

    @Transactional
    public Optional<User> findUserById(@PathVariable Long id) { 
        return userRepository.findById(id);
    }

    @Transactional
    public User createUser(@RequestBody User newUser) {
        return userRepository.save(newUser);
    }
}

package com.dev.mathis.javavuejsapp.service;

import com.dev.mathis.javavuejsapp.model.User;
import com.dev.mathis.javavuejsapp.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    public String findUserByUsername(@PathVariable String username) { 
        List<User> users = getUsers();
        for(User user : users)
            if(user.getUsername() == username)
                return "{\"username\": " + user.getUsername() + ", \"password\": " + user.getPassword() + "}";
        return "null";
    }

    @Transactional
    public User createUser(@RequestBody User newUser) {
        return userRepository.save(newUser);
    }
}

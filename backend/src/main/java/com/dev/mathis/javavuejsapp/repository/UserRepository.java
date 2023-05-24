package com.dev.mathis.javavuejsapp.repository;

import com.dev.mathis.javavuejsapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findUser(User user);
}
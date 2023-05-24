<template>
    <div class="form-div">
        <form>
          <h1 :class="{ 'sign-in': !clicked, 'sign-up': clicked }">{{ clicked ? 'Sign up' : 'Sign in' }}</h1>
          <div class="row">
              <div class="col-25">
                  <label for="username">Username</label>
              </div>
              <div class="col-75">
                  <input type="text" id="username" name="username" placeholder="Your username" v-model="username" required>
              </div>
          </div>
          <div class="row">
              <div class="col-25">
                  <label for="password">Password</label>
              </div>
              <div class="col-75">
                  <input type="text" id="password" name="password" placeholder="Your password" v-model="password" required>
              </div>
          </div>
          <div class="row" style="margin-top:10%">
              <div class="col-50">
                  <p class="create-my-account-or-log-in" @click="clicked = !clicked">{{ clicked ? 'Log in' : 'Create my account' }}</p>
              </div>
              <div class="col-50">
                  <button v-if="clicked" @click="createUser" type="button">Create my account</button>
                  <button v-else @click="signIn" type="button">Submit</button>
              </div>
          </div>
        </form>
    </div>
</template>

<script>
import axios from 'axios';

const USER_API_BASE_URL = '/api/users';

export default {
  data() {
    return {
      clicked: false, 
      username: '', 
      password: ''
    }
  },
  methods: {
    getUser() {
      const url = USER_API_BASE_URL + '/' + this.username
      return axios.get(url, {
        headers: {
          'Accept': 'application/json'
        }
      });
    },
    getUsers() {
      return axios.get(USER_API_BASE_URL, {
        headers: {
          'Accept': 'application/json'
        }
      });
    },
    createUser() {
      console.log("username = " + this.username);
      console.log("password = " + this.password)
      var data = {
        username: this.username,
        password: this.password
      }
      return axios.post(USER_API_BASE_URL, data, {
        headers: {
          'Accept': 'application/json'
        }
      });
    },
    signIn() {
      this.getUser(this.username).then((response) => {
        console.log("response = " + JSON.stringify(response));
        var status = response.status;
        var isUser = (status >= 200 && status < 400);
        var isEmpty = (this.username == '' || this.password == '');

        console.log("isEmpty = " + isEmpty);
        console.log("isUser = " + isUser);

        if(!isEmpty && isUser){
          alert("You're signed in!");
        } else {
          alert("Unknown user!");
        }
      });
    }
  }
}
</script>

<style>
h1 {
   color: black;
   margin-bottom: 5%;
}

.sign-in {
  color: blue;
}

.sign-up {
  color: green;
}

.create-my-account-or-log-in {
    color: gray;
    text-decoration: underline;
    float: left;
}

.create-my-account-or-log-in:hover {
    cursor: pointer;
}

/* Style inputs, select elements and textareas */
input[type=text]{
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  resize: vertical;
}

/* Style the label to display next to the inputs */
label {
  color: black;
  padding: 12px 100px 12px 0;
  display: inline-block;
}

/* Style the submit button */
button {
  background-color: #04AA6D;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  float: right;
}

/* Style the container */
.form-div {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}

/* Floating column for labels: 25% width */
.col-25 {
  float: left;
  width: 25%;
  margin-top: 6px;
}

/* Floating column for inputs: 75% width */
.col-75 {
  float: left;
  width: 75%;
  margin-top: 6px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

/* Responsive layout - when the screen is less than 600px wide, make the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 600px) {
  .col-25, .col-75, input[type=submit] {
    width: 100%;
    margin-top: 0;
  }
}
</style>
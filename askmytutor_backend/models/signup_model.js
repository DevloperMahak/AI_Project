const mongoose = require("mongoose");
const db = require('../config/db');
const bcrypt = require('bcrypt');
const crypto = require('crypto');

const {Schema} = mongoose;

const signupSchema = new mongoose.Schema({
    name:{
    type:String,
    required:true
   },
   email:{
    type:String,
    required:true
   },
   password:{
    type:String,
    required:true
   },
})

signupSchema.pre('save',async function(next) {
    try{
     var user = this;

     // Only hash the password if it's new or modified
    if (!user.isModified('password')) {
        return next();
      }

      const salt = await(bcrypt.genSalt(10));
      const hashpass = await bcrypt.hash(user.password,salt);

      user.password = hashpass;

      next();

    }catch(error){
        return next(error);
    }
})



const signupModel = new mongoose.model("users_Data",signupSchema);
module.exports = signupModel;
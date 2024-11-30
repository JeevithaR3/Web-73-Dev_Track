const mongoose=require("mongoose")
const connect=mongoose.connect("mongodb://localhost:27017/aadhar360");

connect.then(()=>{
    console.log("Database connected successfully");
})

.catch(()=>{
    console.log("Database cannotbe connected");
})

const LoginSchema=new mongoose.Schema({
    name:{
        type: String,
        required: true
    },
    password: {
        type:String,
        required: true
    }
});


const collection= new mongoose.model("users",LoginSchema);

module.exports=collection;
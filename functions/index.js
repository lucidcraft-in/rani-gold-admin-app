const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();
exports.balanceUpdate =
    functions.pubsub.schedule("* * * 1 1").onRun((context)=>{
      let CustBalance = 0;
      const query = database.collection("user")
          .where("balance", "<", 0)
          .get().then((querySnapshot)=>{
            querySnapshot.forEach((doc) => {
              const schemeType = doc.data()["schemeType"];
              const token = doc.data()["token"];
              CustBalance = doc.data()["balance"];
              const StaffId = doc.data()["staffId"];
              console.log("check queryyyyyyyyyyyyyyy" +CustBalance);
              console.log("check tokennn" +token);
              // console.log(`${doc.id} => ${doc.data()["schemeType"]}`);
              const queryTrans= database.collection("transactions").
                  where("customerId", "=", doc.id)
                  .orderBy("date").limit(1)
                  .get().then((querySnapshottran) => {
                    querySnapshottran.forEach((docTran) => {
                      const lastDate = docTran.data()["date"];
                      const currentDate = admin.firestore.Timestamp.now();
                      const diffTime = Math.abs(currentDate - lastDate);
                      const diffDays = Math.ceil(diffTime/(1000* 60 * 60 * 24));
                      console.log("check diff dates query +++++++++"+diffDays);
                      console.log("check transaction query----------"+lastDate);
                      if (schemeType == "Monthly") {
                        if (diffDays >= 29) {
                          const payloadreminder = {
                            token: token,
                            notification: {
                              title: "Reminder",
                              body: "Your payment date is tommorrow",
                            },
                            data: {
                              body: "Your payment date is tommorrow",
                            },
                          };
                          admin.messaging().send(payloadreminder).
                              then((response) => {
                                console.log("Successfully sent message:",
                                    response);
                                return {success: true};
                              }).catch((error) => {
                                return {error: error.code};
                              });
                        }
                        if (diffDays >= 30) {
                          CustBalance = CustBalance - 100;
                          database.collection("transactions").add({
                            "customerId": doc.id,
                            "date": admin.firestore.Timestamp.now(),
                            "amount": parseFloat((100.0).toFixed(1)),
                            "note": "Fine Amount",
                            "transactionType": 1,
                            "timestamp": admin.firestore.Timestamp.now(),
                            "staffId": StaffId,
                            "customerName": "",
                            "invoiceNo": "",
                            "category": "",
                            "discount": parseFloat((0).toFixed(1)),
                          });
                          database.doc("user/" + doc.id).update({
                            "balance": parseFloat((CustBalance).toFixed(1)),
                            "timestamp": admin.firestore.Timestamp.now(),
                          });
                          console.log("iam inside functiiiiiiiii");
                          const payload = {
                            token: token,
                            notification: {
                              title: "Fine Credited",
                              body: "RS 100 credited to your account",
                            },
                            data: {
                              body: "RS 100 credited to your account",
                            },
                          };
                          admin.messaging().send(payload).
                              then((response) => {
                                console.log("Successfully sent message:",
                                    response);
                                return {success: true};
                              }).catch((error) => {
                                return {error: error.code};
                              });
                        }
                      } else if (schemeType == "Weekly") {
                        if (diffDays >= 7) {
                          const payloadreminder = {
                            token: token,
                            notification: {
                              title: "Reminder",
                              body: "Your payment date is tommorrow",
                            },
                            data: {
                              body: "Your payment date is tommorrow",
                            },
                          };
                          admin.messaging().send(payloadreminder).
                              then((response) => {
                                console.log("Successfully sent message:",
                                    response);
                                return {success: true};
                              }).catch((error) => {
                                return {error: error.code};
                              });
                        }
                        if (diffDays >= 8) {
                          CustBalance = CustBalance - 50;
                          database.collection("transactions").add({
                            "customerId": doc.id,
                            "date": admin.firestore.Timestamp.now(),
                            "amount": parseFloat((50.0).toFixed(1)),
                            "note": "Fine Amount",
                            "transactionType": 1,
                            "timestamp": admin.firestore.Timestamp.now(),
                            "staffId": StaffId,
                            "customerName": "",
                            "invoiceNo": "",
                            "category": "",
                            "discount": parseFloat((0).toFixed(1)),
                          });
                          database.doc("user/" + doc.id).update({
                            "balance": parseFloat(CustBalance.toFixed(1)),
                            "timestamp": admin.firestore.Timestamp.now(),
                          });
                          const payload = {
                            token: token,
                            notification: {
                              title: "Fine Credited",
                              body: "RS 100 credited to your account",
                            },
                            data: {
                              body: "RS 100 credited to your account",
                            },
                          };
                          admin.messaging().send(payload).
                              then((response) => {
                                console.log("Successfully sent message:",
                                    response);
                                return {success: true};
                              }).catch((error) => {
                                return {error: error.code};
                              });
                        }
                      }
                    });
                  });
              console.log("chceck transa query------------" +queryTrans);
            });
          });
      console.log("chceck user query------------" +typeof query);
      return console.log("successfully balance update");
    });

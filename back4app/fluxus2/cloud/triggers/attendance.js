Parse.Cloud.afterDelete("Attendance", async (req) => {
  let curObj = req.object;
  const query = new Parse.Query("Event");
  query.equalTo("attendance", curObj);

  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      const relation = result.relation("attendance");
      relation.remove(curObj);
      await result.save(null, { useMasterKey: true });
    }
  }
});
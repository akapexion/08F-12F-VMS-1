
<?php
include("base/header.php");

  if(isset($_POST['addchild'])){
       extract($_POST);

        $insert_query = "INSERT INTO childs1(child_name, child_parent_name, child_parent_contact, child_gender, child_dob) VALUES('$child_name')";

        $execute = mysqli_query($connection_ref, $insert_query);
    }

?>

<div class="page-header">
    <div>
        <h1 class="page-title">Children Management</h1>
        <p class="page-subtitle">
            Manage children's records and information.
        </p>
    </div>

    <button type="button"
            class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#addChildModal">
        <i class="bi bi-plus-lg"></i> Add Child
    </button>
</div>

<div class="card mt-4">
    <div class="card-body">

        <div class="row mb-3">
            <div class="col-md-6">
                <input type="text"
                       id="childSearch"
                       class="form-control"
                       placeholder="Search children...">
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle"
                   id="childrenTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Child Name</th>
                        <th>Child Parent Name</th>
                        <th>Child Parent Contact</th>
                        <th>Date of Birth</th>
                        <th>Gender</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                     <?php
                        $select_query = "SELECT * FROM childs1";
                        $result = mysqli_query($conn, $select_query);
                        while($display = mysqli_fetch_array($result)){
                    ?>
                    <tr>
                        <td><?php echo $display['child_id'];  ?></td>
                        <td><?php echo $display['child_name'];  ?></td>
                        <td><?php echo $display['child_parent_name'];  ?></td>
                        <td><?php echo $display['child_parent_contact'];  ?></td>
                        <td><?php echo $display['date_of_birth'];  ?></td>
                        <td><?php echo $display['gender'];  ?></td>
                        <td>
                            <a href="">Edit</a>
                            <a href="">Delete</a>
                        </td>
                    </tr>
                    <?php
                        }
                    ?>
                </tbody>
            </table>
        </div>

    </div>
</div>

<!--///// Add Child  /////-->
<div class="modal fade"
     id="addChildModal"
     tabindex="-1"
     aria-labelledby="addChildModalLabel"
     aria-hidden="true">

    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <form id="addChildForm" method="POST">

                <div class="modal-header">
                    <h5 class="modal-title" id="addChildModalLabel">
                        Add New Child
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>

                <div class="modal-body">

                    <div class="row g-3">

                    

                        <div class="col-md-6">
                            <label class="form-label">Child Full Name</label>
                            <input type="text"
                                   name="child_name"
                                   class="form-control"
                                   required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Date of Birth</label>
                            <input type="date"
                                   name="date_of_birth"
                                   class="form-control"
                                   required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Gender</label>
                            <select name="gender"
                                    class="form-select"
                                    required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Parent Name</label>
                            <input type="text"
                                   name="parent_name"
                                   class="form-control"
                                   required>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label">Parent Contact</label>
                            <input type="tel"
                                   name="parent_contact"
                                   class="form-control"
                                   placeholder="Enter phone number">
                        </div>

                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        Cancel
                    </button>

                    <button type="submit" name="addchild" class="btn btn-primary">
                        Save Child
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

<script>

document.getElementById("childSearch").addEventListener("input", function () {
    const searchText = this.value.toLowerCase();

    document.querySelectorAll("#childrenTable tbody tr").forEach(function (row) {
        row.style.display = row.innerText.toLowerCase().includes(searchText)
            ? ""
            : "none";
    });
});


document.getElementById("addChildForm").addEventListener("submit", function (event) {
    event.preventDefault();

    alert("The form is ready. Database saving will be added in the next step.");
});
</script>

<?php
include("base/footer.php");
?>

import public_method_continuous_integration
import public_view_continuous_integration
import bump_up
import distribute_test_app
import update_sdk_version

EXIT = 0
BUMP_UP_TEST_APP = 1
DISTRIBUTE_TEST_APP = 2
SDK_INTEGRATION = 3

def helpMessage():
    print("0: exit")
    print("1: bump up test app")
    print("2: distribute test app")
    print("3: native sdk integeration")

helpMessage()

while 1:
    COMMAND = int(input())

    if COMMAND == BUMP_UP_TEST_APP:
        bump_up.run()
        break
    elif COMMAND == DISTRIBUTE_TEST_APP:
        distribute_test_app.run()
        break
    elif COMMAND == SDK_INTEGRATION:
        update_sdk_version.run()
        break
    elif COMMAND == EXIT:
        break
    else:
        helpMessage()
        print("check command number")

# print("==Flutter Plugin Inteface Generator==")
# print("1. Make Views & Methods")
# print("2. Make Views")
# print("3. Make Methods")
# result = input("Enter:")

# if result == "1":
#     public_view_continuous_integration.add_view()
#     public_method_continuous_integration.add_method()    
# elif result == "2":
#     public_view_continuous_integration.add_view()
# else:
#     public_method_continuous_integration.add_method()

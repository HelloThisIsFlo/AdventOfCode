
def prompt_user_for_input():
    user_input = input("> ")
    try:
        return int(user_input)
    except ValueError:
        print("Please enter a number!")
        return prompt_user_for_input()


def display_output_to_user(output):
    print(f"{output}")

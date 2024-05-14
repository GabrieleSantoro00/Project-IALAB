import tkinter as tk
from tkinter import simpledialog

class LabyrinthDesigner:
    def __init__(self):
        setup_window = tk.Tk()
        setup_window.geometry("300x200")  # Set the size of the window
        setup_window.withdraw()  # Hide the main window
        self.rows = simpledialog.askinteger("Setup", "Enter number of rows", parent=setup_window, minvalue=1)
        self.cols = simpledialog.askinteger("Setup", "Enter number of columns", parent=setup_window, minvalue=1)
        initial_row = simpledialog.askinteger("Setup", "Enter initial node row", parent=setup_window, minvalue=0, maxvalue=self.rows-1)
        initial_col = simpledialog.askinteger("Setup", "Enter initial node column", parent=setup_window, minvalue=0, maxvalue=self.cols-1)
        self.initial_state = (initial_row, initial_col)
        self.goal_states = []
        while True:
            goal_row = simpledialog.askinteger("Setup", "Enter goal node row, cancel to stop creating goal nodes", parent=setup_window, minvalue=0, maxvalue=self.rows-1)
            if goal_row is None:
                break
            goal_col = simpledialog.askinteger("Setup", "Enter goal node column", parent=setup_window, minvalue=0, maxvalue=self.cols-1)
            self.goal_states.append((goal_row, goal_col))
        setup_window.destroy()  # Close the setup window

        self.labyrinth = [[0]*self.cols for _ in range(self.rows)]
        self.window = tk.Tk()
        self.buttons = [[None]*self.cols for _ in range(self.rows)]
        self.save_counter = 0
        for r in range(self.rows):
            for c in range(self.cols):
                self.buttons[r][c] = tk.Button(self.window, command=lambda r=r, c=c: self.toggle_cell(r, c), width=2, height=1)
                self.buttons[r][c].grid(row=r, column=c, padx=1, pady=1)
                if (r, c) == self.initial_state:
                    self.buttons[r][c].config(bg="green")
                elif (r, c) in self.goal_states:
                    self.buttons[r][c].config(bg="red")
        save_button = tk.Button(self.window, text="Save", command=self.save)
        save_button.grid(row=self.rows, column=0, columnspan=self.cols, pady=10)

    def toggle_cell(self, r, c):
        if (r, c) in [self.initial_state] + self.goal_states:
            return
        self.labyrinth[r][c] = 1 - self.labyrinth[r][c]
        self.buttons[r][c].config(bg="black" if self.labyrinth[r][c] == 1 else "white")

    def save(self):
        try:
            with open("counter.txt", "r") as f:
                self.save_counter = int(f.read())
        except FileNotFoundError:
            self.save_counter = 0

        self.save_counter += 1

        with open("counter.txt", "w") as f:
            f.write(str(self.save_counter))

        with open(f"labyrinth{self.save_counter}.pl", "w") as f:
            f.write(f"num_righe({self.rows}).\n")
            f.write(f"num_colonne({self.cols}).\n")
            f.write(f"iniziale(pos({self.initial_state[0]+1},{self.initial_state[1]+1})).\n")
            for goal_state in self.goal_states:
                f.write(f"finale(pos({goal_state[0]+1},{goal_state[1]+1})).\n")
            for r in range(self.rows):
                for c in range(self.cols):
                    if self.labyrinth[r][c] == 1:
                        f.write(f"occupata(pos({r+1},{c+1})).\n")
        print(f"Saved to labyrinth{self.save_counter}.pl")

    def run(self):
        self.window.mainloop()

# Example usage:
designer = LabyrinthDesigner()
designer.run()